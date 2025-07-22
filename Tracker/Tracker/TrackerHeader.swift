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
        categoryLabel.text = "Домашний уют"
        categoryLabel.font = .systemFont(ofSize: 19, weight: .bold)
        categoryLabel.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with text: String) {
        categoryLabel.text = text
    }
}
