//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 17.07.2025.
//

import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func didCreateNewHabit(name: String, category: String, schedule: String)
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
    private lazy var emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForBothCollectionViews)
    private let colorLabel = UILabel()
    private lazy var colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForBothCollectionViews)
    
    private lazy var layoutForBothCollectionViews: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = ((view.bounds.width - 36 - (52 * 6)) / 5)
        layout.minimumLineSpacing = 0
        return layout
    }()
                      
    private let emojisArray = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private var chosenWeekdays: [String : Bool] = [:]
    private var trackerName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        textField.delegate = self
        emojiCollectionView.dataSource = self
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldDidEndEditing(_ textField: UITextField) {
        trackerName = textField.text ?? ""
        if chosenScheduleText.text != "" && chosenScheduleText.text != nil {
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
        delegate?.didCreateNewHabit(name: trackerName, category: "Мок-категория", schedule: chosenScheduleText.text!) // не может быть nil т.к. проверка на nil уже была
        dismiss(animated: true)
    }
}


// MARK: emojiCollectionView data source
extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: "emojiAndColorCell", for: indexPath) as? EmojiAndColorCell
        else {
            return UICollectionViewCell()
        }
        cell.configureCell(emoji: emojisArray[indexPath.item])
        return cell
    }
}


// MARK: view setup
private extension NewHabitViewController {
    private func setupViews() {
        view.backgroundColor = .white
        setUpLabel()
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
    
    private func setUpTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        view.addSubview(categoryButton)
        categoryButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        categoryButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).isActive = true
        categoryButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
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
        view.addSubview(dividerBetweenButtons)
        dividerBetweenButtons.image = UIImage(named: "divider")
        dividerBetweenButtons.topAnchor.constraint(equalTo: categoryButton.bottomAnchor).isActive = true
        dividerBetweenButtons.centerXAnchor.constraint(equalTo: categoryButton.centerXAnchor).isActive = true
        dividerBetweenButtons.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerBetweenButtons.widthAnchor.constraint(equalToConstant: 311).isActive = true
    }
    
    private func setUpScheduleButton() {
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scheduleButton)
        scheduleButton.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor).isActive = true
        scheduleButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        scheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        scheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
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
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
        createButton.setImage(.createButtonDisabled, for: .disabled)
        createButton.setImage(.createButton, for: .normal)
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func setUpCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
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
        if textField.text != "" && textField.text != nil {
            createButton.isEnabled = true
        }
    }
    
    private func setUpEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiLabel)
        emojiLabel.text = "Emoji"
        emojiLabel.font = .systemFont(ofSize: 19, weight: .bold)
        emojiLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32).isActive = true
        emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        emojiLabel.textColor = .black
    }
    
    private func setUpEmojiCollectionView() {
        emojiCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "emojiAndColorCell")
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiCollectionView)
        emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24).isActive = true
        emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        emojiCollectionView.heightAnchor.constraint(equalToConstant: 156).isActive = true
        emojiCollectionView.backgroundColor = .red
    }
    
    private func setUpColorLabel() {
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorLabel)
        colorLabel.textColor = .black
        colorLabel.text = "Цвет"
        colorLabel.font = .systemFont(ofSize: 19, weight: .bold)
        colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40).isActive = true
        colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
    }
    
    private func setUpColorsCollectionView() {
        //colorsCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: "EmojiAndColorCell")
        //colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(colorsCollectionView)
        //colorsCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24).isActive = true
        //colorsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        //colorsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        //colorsCollectionView.heightAnchor.constraint(equalToConstant: 156).isActive = true
    }
}

#Preview {
    NewHabitViewController()
}
