//
//  ProfileVC.swift
//  knowyourflag
//
//  Created by Chris James on 25/06/2024.
//

import UIKit
import Combine

class ProfileVC: UIViewController {
    private let profileViewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var profile: ProfileResponse? = nil
    private let logoutButton = KYFButton(backgroundColor: .systemPink, title: "Logout")
    private let loginButton = KYFButton(backgroundColor: .systemPink, title: "Login")
    private let deleteAccountButton = KYFButton(backgroundColor: .systemRed, title: "Delete Account")
    
    // MARK: Profile fields
    private let emailLabel = UILabel()
    private let emailValueLabel = UILabel()
    private let emailStackView = UIStackView()
    private let nameLabel = UILabel()
    private let nameValueLabel = UILabel()
    private let nameStackView = UIStackView()
    private let joinDateLabel = UILabel()
    private let joinDateValueLabel = UILabel()
    private let joinDateStackView = UIStackView()
    
    // MARK: Login fields
    private let emailTextField = KYFTextField()
    private let emailTextFieldErrorLabel = UILabel()
    private let emailTextFieldStackView = UIStackView()
    
    init(profileViewModel: ProfileViewModel = ProfileViewModel.sharedInstance) {
        self.profileViewModel = profileViewModel
        profileViewModel.login(email: "chris.w4ac@gmail.com", password: "p4r4d31nd34th")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileViewModel.getProfile()
    }
    
    private func resetSubviews() {
        for v in view.subviews {
            v.removeFromSuperview()
        }
    }
}

extension ProfileVC {
    private func setupObservers() {
        profileViewModel.$profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                self?.profile = profile
                self?.resetSubviews()
                
                if profile != nil {
                    self?.configureAuthenticatedView()
                } else {
                    self?.configureUnauthenticatedView()
                }
            }
            .store(in: &cancellables)
    }
}

extension ProfileVC {
    // MARK: Unauthenticated views
    private func configureUnauthenticatedView() {
        configureEmailTextField()
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailTextFieldStackView)
        
        emailTextField.placeholder = "Email"
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        emailTextFieldStackView.axis = .vertical
        emailTextFieldStackView.distribution = .equalSpacing
        emailTextFieldStackView.addArrangedSubview(emailTextField)
        emailTextFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextFieldStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextFieldStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureEmailTextFieldErrorLabel(errorMessage: String = "") {
        emailTextField.layer.borderColor = UIColor.systemRed.cgColor
        emailTextFieldStackView.addArrangedSubview(emailTextFieldErrorLabel)
        
        emailTextFieldErrorLabel.text = errorMessage
        emailTextFieldErrorLabel.textColor = .systemRed
        emailTextFieldErrorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private func removeEmailTextFieldErrorLabel() {
        emailTextField.layer.borderColor = UIColor.systemGray.cgColor
        emailTextFieldErrorLabel.removeFromSuperview()
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
}

extension ProfileVC {
    // MARK: Authenticated views
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
        logoutButton.addTarget(self, action: #selector(attemptLogout), for: .touchUpInside)
        
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
}

extension ProfileVC {
    // MARK: Actions
    @objc private func attemptLogout() {
        presentAlertOnMainThread(
            title: "Logout",
            message: "Are you sure?",
            confirmButtonTitle: "Yes",
            confirmButtonPostDismissAction: logout,
            cancelButtonTitle: "No"
        )
    }
    
    private func logout() {
        profileViewModel.logout()
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
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case self.emailTextField:
            if textField.text == nil || textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                self.configureEmailTextFieldErrorLabel(errorMessage: "Email is required")
            } else if !textField.text!.isValidEmail {
                self.configureEmailTextFieldErrorLabel(errorMessage: "Email is invalid")
            } else {
                self.removeEmailTextFieldErrorLabel()
            }
            break
        default:
            break
        }
    }
    
    private func checkFields() {
        if self.emailTextField.text == nil || self.emailTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.configureEmailTextFieldErrorLabel(errorMessage: "Email is required")
        } else if !self.emailTextField.text!.isValidEmail {
            self.configureEmailTextFieldErrorLabel(errorMessage: "Email is invalid")
        } else {
            self.removeEmailTextFieldErrorLabel()
        }
    }
}
