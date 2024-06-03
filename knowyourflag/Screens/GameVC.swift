//
//  GameVC.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

class GameVC: UIViewController {
    
    let flagImageView = UIImageView()
    let scoreLabel = UILabel()
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureFlagImageView()
        configureScoreLabel()
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
    
    private func configureScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "\(score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 18)
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 75),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        scoreLabel.isUserInteractionEnabled = true
        scoreLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func labelTapped() {
        score += 1
        DispatchQueue.main.async {
            self.scoreLabel.text = "\(self.score)"
        }
    }
}
