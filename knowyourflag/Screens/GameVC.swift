//
//  GameVC.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

class GameVC: UIViewController {
    
    let flagImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureFlagImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .label
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureFlagImageView() {
        view.addSubview(flagImageView)
        let selectedCountryIndex = Int.random(in: 0...Country.all.count - 1)
        let selectedCountry = Country.all[selectedCountryIndex]
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.image = UIImage(named: selectedCountry.code)
        flagImageView.layer.borderColor = UIColor.gray.cgColor
        flagImageView.layer.borderWidth = 1.0
        flagImageView.layer.cornerRadius = 10.0
        flagImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            flagImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor),
        ])
    }
}
