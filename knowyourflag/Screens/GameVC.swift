//
//  GameVC.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

class GameVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .label
        tabBarController?.tabBar.isHidden = true
    }
}
