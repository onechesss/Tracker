//
//  CategoryCell.swift
//  Tracker
//
//  Created by oneche$$$ on 10.08.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    let pickedCategoryImage = UIImageView()
    private let categoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "categoryCell")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        categoryLabel.text = text
    }
}


// MARK: setup view
private extension CategoryCell {
    private func setupView() {
        backgroundColor = .categoriesTableBackground
        selectionStyle = .none
        setUpCategoryLabel()
        setUpPickedCategoryImage()
    }
    
    private func setUpCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        categoryLabel.font = .systemFont(ofSize: 17, weight: .regular)
        categoryLabel.textColor = .black
    }
    
    private func setUpPickedCategoryImage() {
        pickedCategoryImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pickedCategoryImage)
        NSLayoutConstraint.activate([
            pickedCategoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pickedCategoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        pickedCategoryImage.image = UIImage(resource: .pickedCategory)
        pickedCategoryImage.isHidden = true
    }
}
