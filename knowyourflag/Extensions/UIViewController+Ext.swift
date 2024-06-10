//
//  MyCollectionViewCell+Ext.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = KYFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentCountdownOnMainThread(startingNumber: Int) {
        DispatchQueue.main.async {
            let countdownVC = KYFCountdownVC(vc: self, startingNumber: startingNumber)
            countdownVC.modalPresentationStyle = .overFullScreen
            countdownVC.modalTransitionStyle = .crossDissolve
            self.present(countdownVC, animated: true)
        }
    }
}
