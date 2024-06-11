//
//  KYFCountryChoiceView.swift
//  knowyourflag
//
//  Created by Chris James on 07/06/2024.
//

import UIKit

class KYFCountryChoiceView: UIView {
    
    let countryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemPink
        layer.cornerRadius = 8
        
        addSubview(countryLabel)
        
        countryLabel.textAlignment = .center
        countryLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        countryLabel.textColor = .label
        countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.minimumScaleFactor = 0.9
        countryLabel.numberOfLines = 0
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            countryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            countryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setCountry(country: String) {
        countryLabel.text = country
    }
}
