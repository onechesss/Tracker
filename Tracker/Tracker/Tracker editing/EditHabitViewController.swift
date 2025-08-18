//
//  TrackerEditingViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 14.08.2025.
//

import UIKit

protocol EditHabitViewControllerDelegate: AnyObject {
    func didEditExistingHabit(old: Tracker, new: Tracker, to category: TrackerCategory)
}

final class EditHabitViewController: UIViewController, UITextFieldDelegate, ScheduleViewControllerDelegate, CategoryModelDelegate {
    weak var delegate: EditHabitViewControllerDelegate?

    private let label = UILabel()
    private let daysLabel = UILabel()
    private let textField = UITextField()
    private let categoryButton = UIButton()
    private let categoryTextInCategoryButton = UILabel()
    private let chosenCategoryText = UILabel()
    private let scheduleButton = UIButton()
    private let scheduleTextInScheduleButton = UILabel()
    private let chosenScheduleText = UILabel()
    private let cancelButton = UIButton()
    private let saveButton = UIButton()
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
    private var chosenCategory = String()
    
    private let categoryModel = CategoryModel()
    private let cell: TrackerCell
    private var oldTrackerToRemove = Tracker(id: UUID(), name: "", redPartOfColor: 0, greenPartOfColor: 0, bluePartOfColor: 0, emoji: "", schedule: "")
    private let trackerCategoryStore = TrackerCategoryStore()
    
    init(cell: TrackerCell, categories: [TrackerCategory]) {
        self.cell = cell
        daysLabel.text = cell.daysLabel.text
        textField.text = cell.taskLabel.text
        trackerName = cell.taskLabel.text ?? ""
        for category in categories {
            for tracker in category.trackers {
                if tracker.name == cell.taskLabel.text {
                    oldTrackerToRemove = tracker
                    chosenScheduleText.text = tracker.schedule
                    chosenCategoryText.text = category.name
                    chosenCategory = category.name
                    chosenEmoji = tracker.emoji
                    chosenColor = UIColor(red: CGFloat(tracker.redPartOfColor), green: CGFloat(tracker.greenPartOfColor), blue: CGFloat(tracker.bluePartOfColor), alpha: 1)
                }
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        textField.delegate = self
        emojiCollectionView.dataSource = self
        colorsCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        colorsCollectionView.delegate = self
        categoryModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for emoji in emojisArray {
            if emoji == chosenEmoji {
                let index = emojisArray.firstIndex(of: emoji) ?? 0
                collectionView(emojiCollectionView, didSelectItemAt: IndexPath(item: index, section: 0))
            }
        }
        for number in 0...17 {
            let cell = colorsCollectionView.cellForItem(at: IndexPath(row: number, section: 0)) as? EmojiAndColorCell
            let sum1 = (cell?.colorView.backgroundColor?.cgColor.components?[0] ?? 0) - CGFloat(chosenColor.cgColor.components?[0] ?? 0)
            let sum2 = (cell?.colorView.backgroundColor?.cgColor.components?[1] ?? 0) - CGFloat(chosenColor.cgColor.components?[1] ?? 0)
            let sum3 = (cell?.colorView.backgroundColor?.cgColor.components?[2] ?? 0) - CGFloat(chosenColor.cgColor.components?[2] ?? 0)
            if abs(sum1) < 0.001 && abs(sum2) < 0.001 && abs(sum3) < 0.001 {
                collectionView(colorsCollectionView, didSelectItemAt: IndexPath(item: number, section: 0))
            }
        }
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: ScheduleViewControllerDelegate method
    func weekdaysWereChosen(weekdaysDictionary: [String : Bool]) {
        chosenWeekdays = weekdaysDictionary
        resetTextInScheduleButtonLayoutAfterWeekdaysWereChosen()
    }
    
    // MARK: CategoryModelDelegate method
    func categoryWasChosen(chosenCategory: String) {
        self.chosenCategory = chosenCategory
        resetTextInCategoryButtonLayoutAfterCategoryWasChosen()
    }
    
    @objc private func scheduleButtonTapped() {
        let vc = ScheduleViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func categoryButtonTapped() {
        let viewModel = CategoryViewModel(model: categoryModel) { }
        let vc = CategoryViewController(viewModel: viewModel)
        present(vc, animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        let oldCategories = trackerCategoryStore.getCategoriesFromCoreData()
        var newCategoryToAddTrackerToName = String()
        var newCategoryToAddTrackerToTrackers = [Tracker]()
        for category in oldCategories {
            if category.name == chosenCategory {
                newCategoryToAddTrackerToName = category.name
                newCategoryToAddTrackerToTrackers = category.trackers
            }
        }
        let newCategoryToAddTrackerTo = TrackerCategory(name: newCategoryToAddTrackerToName, trackers: newCategoryToAddTrackerToTrackers)
        delegate?.didEditExistingHabit(old: oldTrackerToRemove, new: Tracker(id: oldTrackerToRemove.id,
                                                                             name: trackerName,
                                                                             redPartOfColor: Float(chosenColor.cgColor.components?[0] ?? 0),
                                                                             greenPartOfColor: Float(chosenColor.cgColor.components?[1] ?? 0),
                                                                             bluePartOfColor: Float(chosenColor.cgColor.components?[2] ?? 0),
                                                                             emoji: chosenEmoji, schedule: chosenScheduleText.text ?? ""),
                                       to: TrackerCategory(name: chosenCategory, trackers: newCategoryToAddTrackerTo.trackers)
        )
        dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        trackerName = textField.text ?? ""
        if textField.text != "" && textField.text != nil && chosenScheduleText.text != "" && chosenScheduleText.text != nil && trackerName != "" && chosenEmoji != "" && chosenColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) && chosenCategory != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}


// MARK: emojiCollectionView and colorsCollectionView data source
extension EditHabitViewController: UICollectionViewDataSource {
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
extension EditHabitViewController: UICollectionViewDelegate {
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
        if textField.text != "" && textField.text != nil && chosenScheduleText.text != "" && chosenScheduleText.text != nil && trackerName != "" && chosenEmoji != "" && chosenColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) && chosenCategory != "" {
            saveButton.isEnabled = true
        }
    }
}


// MARK: view setup
private extension EditHabitViewController {
    private func setupViews() {
        view.backgroundColor = .white
        setUpLabel()
        setUpDaysLabel()
        setUpScrollViewAndContentViewInIt()
        setUpTextField()
        setUpCategoryButton()
        setUpDividerBetweenButtons()
        setUpScheduleButton()
        setUpSaveButton()
        setUpCancelButton()
        setUpEmojiLabel()
        setUpEmojiCollectionView()
        setUpColorLabel()
        setUpColorsCollectionView()
        resetTextInScheduleButtonLayoutAfterWeekdaysWereChosen()
        resetTextInCategoryButtonLayoutAfterCategoryWasChosen()
    }
    
    private func setUpLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        label.textAlignment = .center
        label.text = "Редактирование привычки"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func setUpDaysLabel() {
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(daysLabel)
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),
            daysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        daysLabel.font = .systemFont(ofSize: 32, weight: .bold)
        daysLabel.textColor = .black
    }
    
    private func setUpScrollViewAndContentViewInIt() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 92),
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
        textField.textColor = .black
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
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
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
    
    private func setUpSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -34)
        ])
        saveButton.setImage(.saveButton, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        if chosenWeekdaysStrings != [] {
            chosenScheduleText.text = chosenWeekdaysStrings.joined(separator: ", ")
        }
        chosenScheduleText.textColor = .ypGray
        chosenScheduleText.font = .systemFont(ofSize: 17, weight: .regular)
        chosenScheduleText.topAnchor.constraint(equalTo: scheduleTextInScheduleButton.bottomAnchor, constant: 2).isActive = true
        chosenScheduleText.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16).isActive = true
        if textField.text != "" && textField.text != nil && chosenScheduleText.text != "" && chosenScheduleText.text != nil && trackerName != "" && chosenEmoji != "" && chosenColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) && chosenCategory != "" {
            saveButton.isEnabled = true
        }
    }
    
    private func resetTextInCategoryButtonLayoutAfterCategoryWasChosen() {
        categoryTextInCategoryButton.topAnchor.constraint(equalTo: categoryButton.topAnchor, constant: 15).isActive = true
        chosenCategoryText.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.addSubview(chosenCategoryText)
        if chosenCategory != "" {
            chosenCategoryText.text = chosenCategory
        }
        chosenCategoryText.textColor = .ypGray
        chosenCategoryText.font = .systemFont(ofSize: 17, weight: .regular)
        chosenCategoryText.topAnchor.constraint(equalTo: categoryTextInCategoryButton.bottomAnchor, constant: 2).isActive = true
        chosenCategoryText.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16).isActive = true
        if textField.text != "" && textField.text != nil && chosenScheduleText.text != "" && chosenScheduleText.text != nil && trackerName != "" && chosenEmoji != "" && chosenColor != UIColor(red: 0, green: 0, blue: 0, alpha: 1) && chosenCategory != "" {
            saveButton.isEnabled = true
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

