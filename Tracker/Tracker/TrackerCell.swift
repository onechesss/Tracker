//
//  TrackerCell.swift
//  Tracker
//
//  Created by oneche$$$ on 08.07.2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func plusButtonInCellSelected(in cell: TrackerCell)
    func plusButtonInCellDeselected(in cell: TrackerCell)
    var currentDate: Date { get set }
}

final class TrackerCell: UICollectionViewCell {
    weak var delegate: TrackerCellDelegate?
    var id = UUID()
    
    private let taskLabel = UILabel()
    private let emojiLabel = UILabel()
    private let daysLabel = UILabel()
    private let colorView = UIView()
    private let button = UIButton()
    private let emojiBackgroundView = UIView()
    
    private let calendar = Calendar.current
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(task: String, emoji: String, color: UIColor, id: UUID, days: Int, isDoneOnThatDay: Bool) {
        taskLabel.text = task
        emojiLabel.text = emoji
        colorView.backgroundColor = color
        self.id = id
        daysLabel.text = "\(days) \(rightDaysWord(days: days))"
        if isDoneOnThatDay {
            button.isSelected = true
        } else {
            button.isSelected = false
        }
        guard let delegate else { return }
        button.isEnabled = true
        if delegate.currentDate > Date() && !calendar.isDate(delegate.currentDate, inSameDayAs: Date()) {
            button.isEnabled = false
        }
    }
    
    private func rightDaysWord(days: Int) -> String {
        if days == 11 || days == 12 || days == 13 || days == 14 {
            return "дней"
        }
        let remainderOfDivisionByTen = days % 10
        switch remainderOfDivisionByTen {
        case 0:
            return "дней"
        case 1:
            return "день"
        case 2:
            return "дня"
        case 3:
            return "дня"
        case 4:
            return "дня"
        default:
            return "дней"
        }
    }
    
    @objc private func buttonTapped() {
        if button.isSelected {
            delegate?.plusButtonInCellDeselected(in: self)
            button.isSelected = false
// здесь и далее используется force unwrap т.к. свойства точно не nil
            let numberAndWord = daysLabel.text!.components(separatedBy: " ")
            daysLabel.text = "\(Int(numberAndWord[0])! - 1) \(rightDaysWord(days: Int(numberAndWord[0])! - 1))"
        } else {
            delegate?.plusButtonInCellSelected(in: self)
            button.isSelected = true
            let numberAndWord = daysLabel.text!.components(separatedBy: " ")
            daysLabel.text = "\(Int(numberAndWord[0])! + 1) \(rightDaysWord(days: Int(numberAndWord[0])! + 1))"
        }
    }
}


// MARK: setup view
private extension TrackerCell {
    private func setupView() {
        setUpColorView(cv: colorView)
        setUpTaskLabel(label: taskLabel, cv: colorView)
        setUpEmojiBackgroundView(view: emojiBackgroundView)
        setUpEmojiLabel(emojiLabel: emojiLabel, background: emojiBackgroundView)
        setUpDaysLabel(dl: daysLabel)
        setUpButton(button: button)
    }
    
    private func setUpTaskLabel(label: UILabel, cv: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.text = "Поливать растения"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.trailingAnchor.constraint(equalTo: cv.trailingAnchor, constant: 12).isActive = true
        label.leadingAnchor.constraint(equalTo: cv.leadingAnchor, constant: 12).isActive = true
        label.bottomAnchor.constraint(equalTo: cv.bottomAnchor, constant: -12).isActive = true
        label.textAlignment = .left
    }
    
    private func setUpColorView(cv: UIView) {
        cv.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cv)
        cv.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -58).isActive = true
        cv.backgroundColor = .ypGreen
        cv.layer.cornerRadius = 16
    }
    
    private func setUpEmojiBackgroundView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.cornerRadius = 12
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setUpEmojiLabel(emojiLabel: UILabel, background: UIView) {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        emojiLabel.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        emojiLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        emojiLabel.text = "😪"
        emojiLabel.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    private func setUpDaysLabel(dl: UILabel) {
        dl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dl)
        dl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        dl.text = "0 дней"
        dl.textColor = .black
        dl.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private func setUpButton(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12),
            button.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        daysLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.setImage(.cellButton, for: .normal)
        button.setImage(.cellButtonTapped, for: .selected)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}
