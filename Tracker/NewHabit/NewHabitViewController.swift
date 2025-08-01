//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 17.07.2025.
//

import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func didCreateNewHabit(name: String, category: String, schedule: String, emoji: String, color: UIColor)
}

final class NewHabitViewController: UIViewController, UITextFieldDelegate, ScheduleViewControllerDelegate {
    weak var delegate: NewHabitViewControllerDelegate?

    private let label = UILabel()
    private let textField = UITextField()
    private let categoryButton = UIButton()
    private let categoryTextInCategoryButton = UILabel()
    private let chosenCategoryText = UILabel()
    private let scheduleButton = UIButton()
    private let scheduleTextInScheduleButton = UILabel()
    private let chosenScheduleText = UILabel()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let dividerBetweenButtons = UIImageView()
    private let emojiLabel = UILabel()
    private lazy var emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForEmojiCollectionView)
    private let colorLabel = UILabel()
    private lazy var colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForColorCollectionView)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var layoutForEmojiCollectionView: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = ((view.bounds.width - 36 - (52 * 6)) / 5)
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var layoutForColorCollectionView: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = ((view.bounds.width - 36 - (52 * 6)) / 5)
        layout.minimumLineSpacing = 0
        return layout
    }()
                      
    private let emojisArray = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private var trackerName: String = ""
    private var chosenWeekdays: [String : Bool] = [:]
    private var chosenEmoji = ""
    private var chosenColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        textField.delegate = self
        emojiCollectionView.dataSource = self
        colorsCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorsCollectionView.delegate = self
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackerName = textField.text ?? ""
        if chosenScheduleText.text != "" && trackerName != "" && chosenEmoji != "" && chosenColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) {
            createButton.isEnabled = true
        }
    }
    
    // MARK: ScheduleViewControllerDelegate method
    func weekdaysWereChosen(weekdaysDictionary: [String : Bool]) {
        chosenWeekdays = weekdaysDictionary
        resetTextInScheduleButtonLayoutAfterWeekdaysWereChosen()
    }
    
    @objc private func scheduleButtonTapped() {
        let vc = ScheduleViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        delegate?.didCreateNewHabit(name: trackerName, category: "Мок-категория", schedule: chosenScheduleText.text!, emoji: chosenEmoji, color: chosenColor) // не может быть nil т.к. проверка на nil уже была
        dismiss(animated: true)
    }
}


// MARK: emojiCollectionView and colorsCollectionView data source
extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColorCell", for: indexPath) as? EmojiAndColorCell
            else {
                return UICollectionViewCell()
            }
            cell.configureEmoji(emoji: emojisArray[indexPath.item])
            return cell
        } else {
            guard let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColorCell", for: indexPath) as? EmojiAndColorCell
            else {
                return UICollectionViewCell()
            }
            let colorString = "Color \(indexPath.item)"
            cell.configureColor(color: UIColor(named: colorString) ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1))
            return cell
        }
    }
}


// MARK: emojiCollectionView and colorsCollectionView delegate
extension NewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let indexPathsOfVisibleItems = collectionView.indexPathsForVisibleItems
            for iteratingIndexPath in indexPathsOfVisibleItems {
                if iteratingIndexPath != indexPath {
                    let cell = collectionView.cellForItem(at: iteratingIndexPath) as? EmojiAndColorCell
                    cell?.backgroundColor = .white
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell
            cell?.backgroundColor = .chosenEmojiBackground
            cell?.layer.cornerRadius = 16
            cell?.layer.masksToBounds = true
            guard let emoji = cell?.emojiLabel.text else { return }
            chosenEmoji = emoji
        } else {
            let indexPathsOfVisibleItems = collectionView.indexPathsForVisibleItems
            for iteratingIndexPath in indexPathsOfVisibleItems {
                if iteratingIndexPath != indexPath {
                    let cell = collectionView.cellForItem(at: iteratingIndexPath) as? EmojiAndColorCell
                    cell?.selectedColorRing.isHidden = true
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell
            cell?.selectedColorRing.isHidden = false
            guard let color = cell?.colorView.backgroundColor else { return }
            chosenColor = color
        }
        if chosenScheduleText.text != "" && trackerName != "" && chosenEmoji != "" && chosenColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) {
            createButton.isEnabled = true
        }
    }
}


// MARK: view setup
private extension NewHabitViewController {
    private func setupViews() {
        view.backgroundColor = .white
        setUpLabel()
        setUpScrollViewAndContentViewInIt()
        setUpTextField()
        setUpCategoryButton()
        setUpDividerBetweenButtons()
        setUpScheduleButton()
        setUpCreateButton()
        setUpCancelButton()
        setUpEmojiLabel()
        setUpEmojiCollectionView()
        setUpColorLabel()
        setUpColorsCollectionView()
    }
    
    private func setUpLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 133).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        label.text = "Новая привычка"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func setUpScrollViewAndContentViewInIt() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 34),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 875)
        ])
    }
    
    private func setUpTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
        textField.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1),
            .font: UIFont.systemFont(ofSize: 17, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: attributes)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
    }
    
    private func setUpCategoryButton() {
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryButton)
        categoryButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        categoryButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).isActive = true
        categoryButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        categoryButton.layer.masksToBounds = true
        categoryButton.layer.cornerRadius = 16
        categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        categoryTextInCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addSubview(categoryTextInCategoryButton)
        categoryTextInCategoryButton.text = "Категория"
        categoryTextInCategoryButton.font = .systemFont(ofSize: 17, weight: .regular)
        categoryTextInCategoryButton.textColor = .black
        categoryTextInCategoryButton.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16).isActive = true
        categoryTextInCategoryButton.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 27).isActive = true
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addSubview(imageView)
        imageView.image = .buttonNext
        NSLayoutConstraint.activate(
            [imageView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
             imageView.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 26)
            ]
        )
    }
    
    private func setUpDividerBetweenButtons() {
        dividerBetweenButtons.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerBetweenButtons)
        dividerBetweenButtons.image = UIImage(named: "divider")
        dividerBetweenButtons.topAnchor.constraint(equalTo: categoryButton.bottomAnchor).isActive = true
        dividerBetweenButtons.centerXAnchor.constraint(equalTo: categoryButton.centerXAnchor).isActive = true
        dividerBetweenButtons.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerBetweenButtons.widthAnchor.constraint(equalToConstant: 311).isActive = true
    }
    
    private func setUpScheduleButton() {
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scheduleButton)
        scheduleButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor).isActive = true
        scheduleButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        scheduleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        scheduleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        scheduleButton.layer.masksToBounds = true
        scheduleButton.layer.cornerRadius = 16
        scheduleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scheduleTextInScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.addSubview(scheduleTextInScheduleButton)
        scheduleTextInScheduleButton.text = "Расписание"
        scheduleTextInScheduleButton.font = .systemFont(ofSize: 17, weight: .regular)
        scheduleTextInScheduleButton.textColor = .black
        scheduleTextInScheduleButton.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16).isActive = true
        scheduleTextInScheduleButton.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 27).isActive = true
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.addSubview(imageView)
        imageView.image = .buttonNext
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 26)
        ])
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
    }
    
    private func setUpCreateButton() {
        createButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
        createButton.setImage(.createButtonDisabled, for: .disabled)
        createButton.setImage(.createButton, for: .normal)
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func setUpCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
        cancelButton.setImage(.cancelButton, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func resetTextInScheduleButtonLayoutAfterWeekdaysWereChosen() {
        scheduleTextInScheduleButton.topAnchor.constraint(equalTo: scheduleButton.topAnchor, constant: 15).isActive = true
        chosenScheduleText.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.addSubview(chosenScheduleText)
        var chosenWeekdaysStrings: [String] = []
        for element in chosenWeekdays {
            if element.value == true {
                chosenWeekdaysStrings.append(element.key)
            }
        }
        chosenScheduleText.text = chosenWeekdaysStrings.joined(separator: ", ")
        chosenScheduleText.textColor = .ypGray
        chosenScheduleText.font = .systemFont(ofSize: 17, weight: .regular)
        chosenScheduleText.topAnchor.constraint(equalTo: scheduleTextInScheduleButton.bottomAnchor, constant: 2).isActive = true
        chosenScheduleText.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16).isActive = true
        if chosenScheduleText.text != "" && trackerName != "" && chosenEmoji != "" && chosenColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) {
            createButton.isEnabled = true
        }
    }
    
    private func setUpEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        emojiLabel.text = "Emoji"
        emojiLabel.font = .systemFont(ofSize: 19, weight: .bold)
        emojiLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32).isActive = true
        emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28).isActive = true
        emojiLabel.textColor = .black
    }
    
    private func setUpEmojiCollectionView() {
        emojiCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "emojiAndColorCell")
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiCollectionView)
        emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24).isActive = true
        emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18).isActive = true
        emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        emojiCollectionView.heightAnchor.constraint(equalToConstant: 156).isActive = true
        emojiCollectionView.backgroundColor = .white
    }
    
    private func setUpColorLabel() {
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorLabel)
        colorLabel.textColor = .black
        colorLabel.text = "Цвет"
        colorLabel.font = .systemFont(ofSize: 19, weight: .bold)
        colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40).isActive = true
        colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28).isActive = true
    }
    
    private func setUpColorsCollectionView() {
        colorsCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "emojiAndColorCell")
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorsCollectionView)
        colorsCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24).isActive = true
        colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18).isActive = true
        colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        colorsCollectionView.heightAnchor.constraint(equalToConstant: 156).isActive = true
        colorsCollectionView.backgroundColor = .white
    }
}

#Preview {
    NewHabitViewController()
}
