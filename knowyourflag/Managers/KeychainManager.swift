//
//  KeychainManager.swift
//  knowyourflag
//
//  Created by Chris James on 25/06/2024.
//

import Foundation

final class KeychainManager {
    static let sharedInstance = KeychainManager()
    
    private init() {}
    
    func save(data: Data, service: String, account: String) {
        // create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        // add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            // needs updating since item already exist
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            // update existing item
            SecItemUpdate(query, attributesToUpdate)
        } else {
            if status != errSecSuccess {
                print("Error saving data into keychain: \(status)")
            }
        }
    }
    
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        // delete item from keychain
        SecItemDelete(query)
    }
}
