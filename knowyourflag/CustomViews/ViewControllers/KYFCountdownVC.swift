//
//  KYFCountdownVC.swift
//  knowyourflag
//
//  Created by Chris James on 10/06/2024.
//

import UIKit

class KYFCountdownVC: UIViewController {

    let containerView = UIView()
    let countdownLabel = UILabel()
    
    var callingVC: UIViewController?
    var startingNumber: Int?
    var timer = Timer()
    
    init(vc: UIViewController, startingNumber: Int) {
        super.init(nibName: nil, bundle: nil)
        self.callingVC = vc
        self.startingNumber = startingNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureCountdownLabel()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
        ])
    }
    
    private func configureCountdownLabel() {
        let height = CGFloat(75)
        
        view.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.text = "\(startingNumber!)"
        countdownLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        countdownLabel.textAlignment = .center
        countdownLabel.backgroundColor = .systemPink
        countdownLabel.layer.masksToBounds = true
        countdownLabel.layer.cornerRadius = height / 2
        
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countdownLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: height),
            countdownLabel.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func setCountdownLabelText(text: String) {
        countdownLabel.text = text
    }
    
    @objc private func countdown() {
        startingNumber! -= 1
        
        if startingNumber == 0 {
            setCountdownLabelText(text: "Go!")
            timer.invalidate()
            dismissVC()
        } else {
            setCountdownLabelText(text: "\(startingNumber!)")
        }
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
        
        switch callingVC {
        case is GuessTheCountryVC:
            let vc = callingVC as! GuessTheCountryVC
            vc.startGameTimer()
            break
        default:
            break
        }
    }
}
