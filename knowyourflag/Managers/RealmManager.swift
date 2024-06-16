//
//  RealmManager.swift
//  knowyourflag
//
//  Created by Chris James on 15/06/2024.
//

import Foundation
import RealmSwift

class RealmManager {
    private var database: Realm!
    private let schemaVersion: UInt64 = 1
    
    /// The shared instance of the realm manager.
    static let sharedInstance = RealmManager()
    
    /// Private initializer for the realm manager. Crashes if it cannot open the database.
    private init() {
        setupRealm()
    }
    
    private func setupRealm() {
        database = encryptedRealm()
    }
    
    private func encryptedRealm() -> Realm {
        let realmKey = getEncryptionKey()
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let encryptedPath = "\(documentDirectory)/default_new.realm"
        
        if shouldCopyUnencryptedRealm(at: documentDirectory, to: encryptedPath) {
            copyUnencryptedRealm(to: encryptedPath, using: realmKey)
        }

        let config = Realm.Configuration(
            fileURL: URL(fileURLWithPath: encryptedPath),
            encryptionKey: realmKey,
            schemaVersion: schemaVersion
        ) { migration, oldSchemaVersion in
            // migration logic if needed
        }

        return try! Realm(configuration: config)
    }
    
    private func shouldCopyUnencryptedRealm(at directory: String, to path: String) -> Bool {
        let fileManager = FileManager.default
        let unencryptedRealmPath = "\(directory)/default.realm"
        return fileManager.fileExists(atPath: unencryptedRealmPath) && !fileManager.fileExists(atPath: path)
    }

    private func copyUnencryptedRealm(to path: String, using key: Data) {
        let unencryptedRealm = try! Realm(configuration: Realm.Configuration(schemaVersion: schemaVersion))
        try? unencryptedRealm.writeCopy(toFile: URL(fileURLWithPath: path), encryptionKey: key)
    }
    
    private func getEncryptionKey() -> Data {
        let keychainIdentifier = "io.Realm.EncryptionKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }
        
        // no pre-existing key from this app, therefore generate new one
        // generate random encryption key
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }
    
    public func fetch<Element: RealmFetchable>(_ type: Element.Type) -> Results<Element> {
        return database.objects(type)
    }
    
    /// Writes the given object to the database.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func save<T: Object>(object: T, _ errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.add(object)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    public func save<S: Sequence>(object: S, _ errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) where S.Iterator.Element: Object {
        do {
            try database.write {
                database.add(object)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// Overwrites the given object in the database if it exists. If not, it will write it as a new object.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func update<T: Object>(object: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.add(object, update: .all)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    public func update(
        writeTransaction: @escaping () throws -> Void,
        errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }
    ) {
        do {
            try database.write {
                try writeTransaction()
            }
        } catch {
            errorHandler(error)
        }
    }
    
    /// Deletes the given object from the database if it exists.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func delete<T: Object>(object: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.delete(object)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    public func delete<S: Sequence>(object: S, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) where S.Iterator.Element: Object {
        do {
            try database.write {
                database.delete(object)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    public func delete<T: ObjectBase>(objects: Results<T>, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.delete(objects)
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// Deletes all existing data from the database. This includes all objects of all types.
    /// Custom error handling available as a closure parameter (default just returns).
    ///
    /// - Returns: Nothing
    public func deleteAll(errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }) {
        do {
            try database.write {
                database.deleteAll()
            }
        }
        catch {
            errorHandler(error)
        }
    }
}
