//
//  GameVC.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

class GuessTheCountryVC: UIViewController {
    
    let flagImageView = UIImageView()
    let scoreLabel = UILabel()
    var choiceViews = [
        KYFCountryChoiceView(),
        KYFCountryChoiceView(),
        KYFCountryChoiceView(),
        KYFCountryChoiceView()
    ]
    
    var selectedCountriesIndex = [Int]()
    var selectedCountryIndex = -1
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureFlagImageView()
        pickCountriesFlag()
        configureScoreLabel()
        configureCountryChoiceViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .label
        tabBarController?.tabBar.isHidden = true
    }
    
    private func pickCountriesFlag() {
        var countryIndexSet = Set<Int>()
        var selectedCountries = [Country]()
        
        while countryIndexSet.count < 4 {
            let randomIndex = Int(arc4random_uniform(UInt32(Country.all.count)))
            countryIndexSet.insert(randomIndex)
        }
        
        selectedCountriesIndex = Array(countryIndexSet)
        
        for i in 0...selectedCountriesIndex.count - 1 {
            let country = Country.all[selectedCountriesIndex[i]]
            selectedCountries.append(country)
        }
        
        selectedCountryIndex = Int.random(in: 0...selectedCountries.count - 1)
        
        setFlagImage()
    }
    
    private func configureFlagImageView() {
        view.addSubview(flagImageView)
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setFlagImage() {
        let selectedCountry = Country.all[selectedCountriesIndex[selectedCountryIndex]]
        flagImageView.image = UIImage(named: selectedCountry.code)
    }
    
    private func configureScoreLabel() {
        let height = CGFloat(75)
        
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "\(score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = .systemPink
        scoreLabel.layer.masksToBounds = true
        scoreLabel.layer.cornerRadius = height / 2
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: height),
            scoreLabel.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func configureCountryChoiceViews() {
        var prev = choiceViews.first!
        
        for (index, choiceView) in choiceViews.enumerated() {
            view.addSubview(choiceView)
            choiceView.translatesAutoresizingMaskIntoConstraints = false
            
            if (index == 0) {
                NSLayoutConstraint.activate([
                    choiceView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30),
                    choiceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                    choiceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
                ])
            } else {
                NSLayoutConstraint.activate([
                    choiceView.topAnchor.constraint(equalTo: prev.bottomAnchor, constant: 10),
                    choiceView.leadingAnchor.constraint(equalTo: prev.leadingAnchor),
                    choiceView.trailingAnchor.constraint(equalTo: prev.trailingAnchor)
                ])
                
                prev = choiceView
            }
        }
        
        setCountryChoiceViewsText()
    }
    
    private func setCountryChoiceViewsText() {
        for i in 0...selectedCountriesIndex.count - 1 {
            let tapGesture = KYFCountryChoiceGestureRecognizer(target: self, action: #selector(evaluateChoice))
            tapGesture.selectedCountryIndex = i
            choiceViews[i].setCountry(country: Country.all[selectedCountriesIndex[i]].name)
            choiceViews[i].isUserInteractionEnabled = true
            choiceViews[i].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func evaluateChoice(sender: KYFCountryChoiceGestureRecognizer) {
        DispatchQueue.main.async {
            if sender.selectedCountryIndex == self.selectedCountryIndex {
                self.score += 1
                self.scoreLabel.text = "\(self.score)"
            }
            
            self.pickCountriesFlag()
            self.setCountryChoiceViewsText()
        }
    }
}
