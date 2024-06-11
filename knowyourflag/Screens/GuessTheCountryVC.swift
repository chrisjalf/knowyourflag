//
//  GameVC.swift
//  knowyourflag
//
//  Created by Chris James on 03/06/2024.
//

import UIKit

class GuessTheCountryVC: UIViewController {
    
    let flagImageView = UIImageView()
    let remaingTimeLabel = UILabel()
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
    var remainingTime = 0
    
    var gameTimer = Timer()
    
    init(remainingTime: Int) {
        super.init(nibName: nil, bundle: nil)
        self.remainingTime = remainingTime
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureFlagImageView()
        pickCountries()
        configureRemainingTimeLabel()
        configureScoreLabel()
        configureCountryChoiceViews()
        
        presentCountdownOnMainThread(startingNumber: 3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .label
        tabBarController?.tabBar.isHidden = true
    }
    
    private func pickCountries() {
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
    
    private func configureRemainingTimeLabel() {
        let height = CGFloat(75)
        
        view.addSubview(remaingTimeLabel)
        remaingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remaingTimeLabel.text = "\(remainingTime)"
        remaingTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        remaingTimeLabel.textAlignment = .center
        remaingTimeLabel.backgroundColor = .systemPink
        remaingTimeLabel.layer.masksToBounds = true
        remaingTimeLabel.layer.cornerRadius = height / 2
        
        NSLayoutConstraint.activate([
            remaingTimeLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 20),
            remaingTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            remaingTimeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: height),
            remaingTimeLabel.heightAnchor.constraint(equalToConstant: height)
        ])
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
            
            self.pickCountries()
            self.setCountryChoiceViewsText()
        }
    }
    
    func startGameTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
    }
    
    @objc private func countdown() {
        remainingTime -= 1
        
        DispatchQueue.main.async {
            self.remaingTimeLabel.text = "\(self.remainingTime)"
        }
        
        if remainingTime == 0 {
            gameTimer.invalidate()
        }
    }
}
