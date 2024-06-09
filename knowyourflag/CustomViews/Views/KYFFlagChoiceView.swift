//
//  KYFFlagChoiceView.swift
//  knowyourflag
//
//  Created by Chris James on 09/06/2024.
//

import UIKit

class KYFFlagChoiceView: UIView {
    
    let flagImageView = UIImageView()
    
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
        
        addSubview(flagImageView)
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: self.topAnchor),
            flagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            flagImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            flagImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor),
        ])
    }
    
    func setFlag(image: UIImage) {
        flagImageView.image = image
    }
}
