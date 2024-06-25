//
//  ProfileVC.swift
//  knowyourflag
//
//  Created by Chris James on 25/06/2024.
//

import UIKit

class ProfileVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.profile { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(let data):
                print("profile: \(data)")
                break
            case .failure(let err):
                print("error: \(err)")
                break
            }
        }
    }
    
}
