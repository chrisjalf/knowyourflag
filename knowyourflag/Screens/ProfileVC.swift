//
//  ProfileVC.swift
//  knowyourflag
//
//  Created by Chris James on 25/06/2024.
//

import UIKit

class ProfileVC: UIViewController {
    private var isAuthenticated: Bool!
    private var profile: ProfileResponse? = nil
    private let logoutButton = KYFButton(backgroundColor: .systemPink, title: "Logout")
    private let loginButton = KYFButton(backgroundColor: .systemPink, title: "Login")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.sharedInstance.profile { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(let data):
                self?.profile = data
                self?.isAuthenticated = true
                DispatchQueue.main.async {
                    self?.configureLogoutButton()
                }
                break
            case .failure(_):
                self?.profile = nil
                self?.isAuthenticated = false
                DispatchQueue.main.async {
                    self?.configureLoginButton()
                }
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func removeSubviews() {
        for v in view.subviews {
           v.removeFromSuperview()
        }
    }
    
    @objc private func logout() {
        KeychainManager.sharedInstance.delete(service: "access_token", account: "kyf")
        removeSubviews()
        configureLoginButton()
    }
}
