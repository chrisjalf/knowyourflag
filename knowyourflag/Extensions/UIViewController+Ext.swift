//
//  MyCollectionViewCell+Ext.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String, buttonPostDismissAction: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            let alertVC = KYFAlertVC(title: title, message: message, buttonTitle: buttonTitle, buttonPostDismissAction: buttonPostDismissAction)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentAlertOnMainThread(
        title: String,
        message: String,
        confirmButtonTitle: String,
        confirmButtonPostDismissAction: @escaping () -> Void = {},
        cancelButtonTitle: String,
        cancelButtonPostDismissAction: @escaping () -> Void = {}
    ) {
        DispatchQueue.main.async {
            let alertVC = KYFAlertVC(
                title: title,
                message: message,
                confirmButtonTitle: confirmButtonTitle,
                confirmButtonPostDismissAction: confirmButtonPostDismissAction,
                cancelButtonTitle: cancelButtonTitle,
                cancelButtonPostDismissAction: cancelButtonPostDismissAction
            )
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentCountdownOnMainThread(startingNumber: Int, postDismissAction: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            let countdownVC = KYFCountdownVC(vc: self, startingNumber: startingNumber, postDismissAction: postDismissAction)
            countdownVC.modalPresentationStyle = .overFullScreen
            countdownVC.modalTransitionStyle = .crossDissolve
            self.present(countdownVC, animated: true)
        }
    }
}
