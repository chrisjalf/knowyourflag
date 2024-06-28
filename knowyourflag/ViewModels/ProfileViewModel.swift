//
//  LoginViewModel.swift
//  knowyourflag
//
//  Created by Chris James on 28/06/2024.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    static let sharedInstance = ProfileViewModel()
    @Published var profile: ProfileResponse? = nil
    @Published var isAuthenticated = false
    
    private init() {}
    
    func getProfile() {
        let apiManager = APIManager.sharedInstance
        apiManager.profile { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(let data):
                self?.profile = data
                self?.isAuthenticated = true
                break
            case .failure(_):
                self?.logout()
                break
            }
        }
    }
    
    func login(email: String, password: String) {
        APIManager.sharedInstance.login(request: LoginRequest(email: email, password: password)) { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(let data):
                KeychainManager.sharedInstance.save(data: Data(data.access_token.utf8), service: "access_token", account: "kyf")
                self?.getProfile()
                break
            case .failure(let err):
                print("error: \(err.rawValue)")
                break
            }
        }
    }
    
    func logout() {
        APIManager.sharedInstance.clearAccessToken()
        profile = nil
        isAuthenticated = false
    }
}
