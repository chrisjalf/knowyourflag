//
//  APIManager.swift
//  knowyourflag
//
//  Created by Chris James on 16/06/2024.
//

import Foundation

class APIManager {
    
    static let sharedInstance = APIManager()
    private let baseUrl = "http://127.0.0.1:3000"
    
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
}
