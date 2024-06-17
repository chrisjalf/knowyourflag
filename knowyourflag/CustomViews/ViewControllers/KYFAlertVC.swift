//
//  KYFAlertVC.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

class KYFAlertVC: UIViewController {
    
    let containerView = UIView()
    let titleLabel = KYFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = KYFBodyLabel(textAlignment: .center)
    let actionButton = KYFButton(backgroundColor: .systemPink, title: "Ok")
    let cancelButton = KYFButton(backgroundColor: .gray, title: "Cancel")
    let buttonStackView = UIStackView()
    
    var alertTitle: String?
    var message: String?
    var confirmButtonTitle: String?
    var confirmButtonPostDismissAction: (() -> Void)!
    
    // optional
    var cancelButtonTitle: String?
    var cancelButtonPostDismissAction: (() -> Void)!
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String, buttonPostDismissAction: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.confirmButtonTitle = buttonTitle
        self.confirmButtonPostDismissAction = buttonPostDismissAction
    }
    
    init(
        title: String,
        message: String,
        confirmButtonTitle: String,
        confirmButtonPostDismissAction: @escaping () -> Void,
        cancelButtonTitle: String,
        cancelButtonPostDismissAction: @escaping () -> Void
    ) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.confirmButtonTitle = confirmButtonTitle
        self.confirmButtonPostDismissAction = confirmButtonPostDismissAction
        self.cancelButtonTitle = cancelButtonTitle
        self.cancelButtonPostDismissAction = cancelButtonPostDismissAction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureTitleLabel()
        
        if let _  = cancelButtonTitle {
            configureActionButtons()
        } else {
            configureActionButton()
        }
        
        configureMessageLabel()
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
        ])
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(confirmButtonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureActionButtons() {
        containerView.addSubview(buttonStackView)
        
        actionButton.setTitle(confirmButtonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        cancelButton.setTitle(cancelButtonTitle ?? "Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(actionButton)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        let bottomAnchorTarget = (cancelButtonTitle != nil) ? buttonStackView.topAnchor : actionButton.topAnchor
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchorTarget, constant: -12)
        ])
    }
    
    func setMessageLabelText(message: String) {
        messageLabel.text = message
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
        confirmButtonPostDismissAction()
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
        cancelButtonPostDismissAction()
    }
}
