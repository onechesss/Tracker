//
//  EmojiCell.swift
//  Tracker
//
//  Created by oneche$$$ on 25.07.2025.
//

import UIKit

final class EmojiAndColorCell: UICollectionViewCell {
    let emojiLabel = UILabel()
    let colorView = UIView()
    let selectedColorRing = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEmoji(emoji: String) {
        emojiLabel.text = emoji
    }
    
    func configureColor(color: UIColor) {
        colorView.backgroundColor = color
        selectedColorRing.layer.borderColor = colorView.backgroundColor?.cgColor.copy(alpha: 0.3)
    }
}


// MARK: setup view
private extension EmojiAndColorCell {
    private func setupView() {
        setUpEmojiLabel()
        setUpColorView()
        setUpSelectedColorRing()
    }
    
    private func setUpEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        emojiLabel.font = .systemFont(ofSize: 32, weight: .bold)
    }
    
    private func setUpColorView() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        colorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        colorView.layer.cornerRadius = 8
    }
    
    private func setUpSelectedColorRing() {
        selectedColorRing.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedColorRing)
        selectedColorRing.widthAnchor.constraint(equalToConstant: 52).isActive = true
        selectedColorRing.heightAnchor.constraint(equalToConstant: 52).isActive = true
        selectedColorRing.layer.cornerRadius = 8
        selectedColorRing.layer.masksToBounds = true
        selectedColorRing.layer.borderWidth = 3
        selectedColorRing.isHidden = true
    }
}
