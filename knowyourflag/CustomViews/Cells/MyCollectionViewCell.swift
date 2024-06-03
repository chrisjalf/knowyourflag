//
//  CollectionViewCell.swift
//  knowyourflag
//
//  Created by Chris James on 02/06/2024.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureCell() {
        contentView.backgroundColor = .systemPink
        contentView.layer.cornerRadius = 30
    }
    
    func configureLabel(_ mode: String) {
        let label = UILabel()
        label.text = mode
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.frame = contentView.bounds
        
        contentView.addSubview(label)
    }
}
