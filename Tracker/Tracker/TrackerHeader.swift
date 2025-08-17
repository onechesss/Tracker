//
//  CollectionViewHeader.swift
//  Tracker
//
//  Created by oneche$$$ on 08.07.2025.
//

import UIKit

final class TrackerHeader: UICollectionReusableView {
    let categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        categoryLabel.font = .systemFont(ofSize: 19, weight: .bold)
        if traitCollection.userInterfaceStyle == .dark {
            categoryLabel.textColor = .white
        } else {
            categoryLabel.textColor = .black
        }
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with text: String) {
        categoryLabel.text = text
    }
}


// MARK: реализация темной и светлой тем
extension TrackerHeader {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *),
           traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                categoryLabel.textColor = .white
            } else {
                categoryLabel.textColor = .black
            }
        }
    }
}
