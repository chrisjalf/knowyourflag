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
    }
    
    private init() {}
    
    func test(completed: @escaping (Result<[GameResult], KYFError>) -> Void) {
        let url = "\(baseUrl)/game-result/test"
        
        guard let url = URL(string: url) else {
            completed(.failure(.error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.error))
                return
            }
            
            guard let data = data else {
                completed(.failure(.error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dt = try decoder.decode([GameResult].self, from: data)
                completed(.success(dt))
            } catch {
                completed(.failure(.error))
            }
        }
        
        task.resume()
    }
    
    func login(request: LoginRequest, completed: @escaping (Result<LoginResponse, KYFError>) -> Void) {
        let url = "\(baseUrl)/auth/login"
        
        guard let url = URL(string: url) else {
            completed(.failure(.error))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.POST.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestBody = try JSONEncoder().encode(request)
            urlRequest.httpBody = requestBody
        } catch {
            completed(.failure(.error))
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completed(.failure(.error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.error))
                return
            }
            
            guard let data = data else {
                completed(.failure(.error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let payload = try decoder.decode(LoginResponse.self, from: data)
                completed(.success(payload))
            } catch {
                completed(.failure(.error))
            }
        }
        
        task.resume()
    }
}
