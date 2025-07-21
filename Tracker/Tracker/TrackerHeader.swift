//
//  CollectionViewHeader.swift
//  Tracker
//
//  Created by oneche$$$ on 08.07.2025.
//

import UIKit

final class TrackerHeader: UICollectionReusableView {
    let categorieLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categorieLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categorieLabel)
        categorieLabel.text = "Домашний уют"
        categorieLabel.font = .systemFont(ofSize: 19, weight: .bold)
        categorieLabel.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with text: String) {
        categorieLabel.text = text
    }
}
