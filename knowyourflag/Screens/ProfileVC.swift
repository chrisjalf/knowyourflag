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
    private let deleteAccountButton = KYFButton(backgroundColor: .systemRed, title: "Delete Account")
    
    // profile fields
    private let emailLabel = UILabel()
    private let emailValueLabel = UILabel()
    private let emailStackView = UIStackView()
    private let nameLabel = UILabel()
    private let nameValueLabel = UILabel()
    private let nameStackView = UIStackView()
    private let joinDateLabel = UILabel()
    private let joinDateValueLabel = UILabel()
    private let joinDateStackView = UIStackView()
    
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
                    self?.configureAuthenticatedView()
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
    
    private func configureAuthenticatedView() {
        configureEmailStackView()
        configureNameStackView()
        configureJoinDateStackView()
        configureLogoutButton()
        configureDeleteAccountButton()
    }
    
    private func configureEmailStackView() {
        view.addSubview(emailStackView)
        
        emailLabel.text = "Email"
        emailLabel.textColor = .label
        emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        emailValueLabel.text = profile?.email ?? "N/A"
        emailValueLabel.textColor = .label
        emailValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        emailStackView.axis = .horizontal
        emailStackView.distribution = .equalSpacing
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailValueLabel)
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            emailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNameStackView() {
        view.addSubview(nameStackView)
        
        nameLabel.text = "Name"
        nameLabel.textColor = .label
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        nameValueLabel.text = profile?.name ?? "N/A"
        nameValueLabel.textColor = .label
        nameValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        nameStackView.axis = .horizontal
        nameStackView.distribution = .equalSpacing
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameValueLabel)
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    private func configureJoinDateStackView() {
        view.addSubview(joinDateStackView)
        
        joinDateLabel.text = "Join Date"
        joinDateLabel.textColor = .label
        joinDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        if let profile = profile {
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputDateFormatter.timeZone = TimeZone.current
            
            if let date = inputDateFormatter.date(from: profile.createdAt) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "yyyy-MM-dd"
                
                let formattedDateString = outputDateFormatter.string(from: date)
                joinDateValueLabel.text = formattedDateString
            } else {
                joinDateValueLabel.text = "N/A"
            }
        } else {
            joinDateValueLabel.text = "N/A"
        }
        joinDateValueLabel.textColor = .label
        joinDateValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        joinDateStackView.axis = .horizontal
        joinDateStackView.distribution = .equalSpacing
        joinDateStackView.addArrangedSubview(joinDateLabel)
        joinDateStackView.addArrangedSubview(joinDateValueLabel)
        joinDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            joinDateStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 20),
            joinDateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            joinDateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
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
    
    private func configureDeleteAccountButton() {
        view.addSubview(deleteAccountButton)
        deleteAccountButton.addTarget(self, action: #selector(attemptDeleteAccount), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteAccountButton.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20),
            deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 50)
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
    
    @objc private func attemptDeleteAccount() {
        presentAlertOnMainThread(
            title: "Delete Account",
            message: "Account cannot be recovered once deleted. Are you sure?",
            confirmButtonTitle: "Yes",
            confirmButtonPostDismissAction: deleteAccount,
            cancelButtonTitle: "No"
        )
    }
    
    private func deleteAccount() {
        APIManager.sharedInstance.delete { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.logout()
                }
                break
            case .failure(let err):
                print("error: \(err.rawValue)")
                break
            }
        }
    }
}
