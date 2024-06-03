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
}
