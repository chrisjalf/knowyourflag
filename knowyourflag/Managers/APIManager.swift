//
//  APIManager.swift
//  knowyourflag
//
//  Created by Chris James on 16/06/2024.
//

import Foundation

class APIManager {
    
    static let sharedInstance = APIManager()
    private let baseUrl = "http://167.71.210.218:3000"
    
    public enum HTTPMethod : String {
        case GET = "GET"
        case POST = "POST"
        case DELETE = "DELETE"
    }
    
    private init() {}
    
    private func getAccessToken() -> String {
        guard let data = KeychainManager.sharedInstance.read(service: "access_token", account: "kyf") else { return "Token empty" }

        return String(data: data, encoding: .utf8)!
    }
    
    func test(completed: @escaping (Result<[GameResult], KYFError>) -> Void) {
        let endpoint = "\(baseUrl)/game-result/test"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.error))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dt = try decoder.decode([GameResult].self, from: data)
                completed(.success(dt))
            } catch {
                completed(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    func login(request: LoginRequest, completed: @escaping (Result<LoginResponse, KYFError>) -> Void) {
        let endpoint = "\(baseUrl)/auth/login"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.POST.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(request)
            urlRequest.httpBody = requestBody
        } catch {
            completed(.failure(.unableToEncode))
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.error))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let payload = try decoder.decode(LoginResponse.self, from: data)
                completed(.success(payload))
            } catch {
                completed(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    func profile(completed: @escaping (Result<ProfileResponse, KYFError>) -> Void) {
        let endpoint = "\(baseUrl)/user/profile"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(getAccessToken())", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.error))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let payload = try decoder.decode(ProfileResponse.self, from: data)
                completed(.success(payload))
            } catch {
                completed(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    func delete(completed: @escaping (Result<Bool, KYFError>) -> Void) {
        let endpoint = "\(baseUrl)/user/delete"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.DELETE.rawValue
        urlRequest.addValue("Bearer \(getAccessToken())", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.error))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            completed(.success(true))
        }
        
        task.resume()
    }
}
