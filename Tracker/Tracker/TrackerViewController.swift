//
//  Tracker.swift
//  Tracker
//
//  Created by oneche$$$ on 22.06.2025.
//

import UIKit

final class TrackerViewController: UIViewController, UITextFieldDelegate, NewHabitViewControllerDelegate, TrackerCellDelegate, EditHabitViewControllerDelegate, TrackersFiltrationDelegate {
    // MARK: TrackerCellDelegate property
    var currentDate = Date()
    
    private let filtersButton = UIButton()
    private let filtersTextOnFiltersButton = UILabel()
    private let errorImage = UIImageView()
    private let textView = UILabel()
    private let nothingFoundImage = UIImageView()
    private let nothingFoundLabel = UILabel()
    private let searchField = UISearchTextField()
    private let trackersTextLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let plusButton = UIButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 167, height: 148)
        layout.minimumInteritemSpacing = 9
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 200, height: 6)
        layout.sectionInset = .init(top: 30, left: 16, bottom: 0, right: 16)
        return layout
    }()
    private lazy var categories: [TrackerCategory] = trackerCategoryStore.getCategoriesFromCoreData()
    private lazy var completedTrackers = trackerRecordStore.getTrackerRecordsFromCoreData()
    private var visibleCategories: [TrackerCategory] = []
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
    private let calendar = Calendar.current
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private var isCompletedTrackersFilterPicked: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        collectionView.dataSource = self
        reloadVisibleCategories()
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: NewHabitViewControllerDelegate method
    func didCreateNewHabit(name: String, category: String, schedule: String, emoji: String, color: UIColor) {
        let id = UUID()
        if let index = categories.firstIndex(where: { $0.name == category }) {
            trackerCategoryStore.addTrackerToCategoryCoreData(category: categories[index], tracker: Tracker(
                id: id,
                name: name,
                redPartOfColor: Float(color.cgColor.components?[0] ?? 0),
                greenPartOfColor: Float(color.cgColor.components?[1] ?? 0),
                bluePartOfColor: Float(color.cgColor.components?[2] ?? 0),
                emoji: emoji,
                schedule: schedule))
            categories = trackerCategoryStore.getCategoriesFromCoreData()
        } else {
            let fetchedCategories = trackerCategoryStore.getCategoriesFromCoreData()
            for element in fetchedCategories {
                if element.name == category {
                    trackerCategoryStore.addTrackerToCategoryCoreData(category: element, tracker: Tracker(id: id, name: name, redPartOfColor: Float(color.cgColor.components?[0] ?? 0), greenPartOfColor: Float(color.cgColor.components?[1] ?? 0), bluePartOfColor: Float(color.cgColor.components?[2] ?? 0), emoji: emoji, schedule: schedule))
                }
            }
            categories = trackerCategoryStore.getCategoriesFromCoreData()
        }
        reloadVisibleCategories()
    }
    
    // MARK: NewHabitViewControllerDelegate method
    func didEditExistingHabit(old: Tracker, new: Tracker, to category: TrackerCategory) {
        trackerCategoryStore.deleteTrackerFromCategoryCoreData(tracker: old)
        let categoryToAddTrackerTo = trackerCategoryStore.getCategoriesFromCoreData().first(where: { $0.name == category.name } ) ?? TrackerCategory(name: "", trackers: [])
        trackerCategoryStore.addTrackerToCategoryCoreData(category: categoryToAddTrackerTo, tracker: new)
        categories = trackerCategoryStore.getCategoriesFromCoreData()
        reloadVisibleCategories()
    }
    
    // MARK: TrackerCellDelegate methods (plusButtonInCellSelected, plusButtonInCellDeselected, presentTrackerEditingViewController, presentDeleteConfirmationAlert)
    func plusButtonInCellSelected(in cell: TrackerCell) {
        trackerRecordStore.addTrackerRecordToCoreData(record: TrackerRecord(id: cell.id, date: currentDate))
        completedTrackers = trackerRecordStore.getTrackerRecordsFromCoreData()
    }
    
    func plusButtonInCellDeselected(in cell: TrackerCell) {
        trackerRecordStore.deleteTrackerRecordInCoreData(record: TrackerRecord(id: cell.id, date: currentDate))
        completedTrackers = trackerRecordStore.getTrackerRecordsFromCoreData()
    }
    
    func presentTrackerEditingViewController(for cell: TrackerCell) {
        let vc = EditHabitViewController(cell: cell, categories: categories)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func presentDeleteConfirmationAlert(for cell: TrackerCell) {
        let alertController = UIAlertController(title: "Уверены, что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            let name = cell.taskLabel.text ?? ""
            let colorComponents = cell.colorView.backgroundColor?.cgColor.components
            let red = Float(colorComponents?[0] ?? 0)
            let green = Float(colorComponents?[1] ?? 0)
            let blue = Float(colorComponents?[2] ?? 0)
            let emoji = cell.emojiLabel.text ?? ""
            let tracker = Tracker(id: cell.id, name: name, redPartOfColor: red, greenPartOfColor: green, bluePartOfColor: blue, emoji: emoji, schedule: "")
            self.trackerCategoryStore.deleteTrackerFromCategoryCoreData(tracker: tracker)
            self.categories = trackerCategoryStore.getCategoriesFromCoreData()
            self.reloadVisibleCategories()
        }))
        alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        present(alertController, animated: true)
    }
    
    // MARK: TrackerFilterDelegate method
    func didSelectFilter(_ filter: String) {
        switch filter {
        case "Трекеры на сегодня":
            isCompletedTrackersFilterPicked = nil
            datePicker.setDate(Date(), animated: true)
            datePickerValueChanged()
        case "Завершенные":
            isCompletedTrackersFilterPicked = true
            reloadVisibleCategoriesAfterPickingFilter(needToShowCompleted: true)
        case "Не завершенные":
            isCompletedTrackersFilterPicked = false
            reloadVisibleCategoriesAfterPickingFilter(needToShowCompleted: false)
        default:
            isCompletedTrackersFilterPicked = nil
            filtersTextOnFiltersButton.textColor = .white
        }
    }
    
    private func reloadVisibleCategories() {
        let dateString = dateFormatter.string(from: currentDate)
        // фильтрация по дате из datePicker
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { $0.schedule.contains(dateString) }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: filteredTrackers)
        }
        // фильтрация по названию трекера из searchField (только если набран текст в searchField)
        if let text = searchField.text,
           !text.isEmpty {
            visibleCategories = visibleCategories.compactMap { category in
                let filteredTrackers = category.trackers.filter { $0.name.lowercased().contains(text.lowercased()) }
                return filteredTrackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: filteredTrackers)
            }
        }
        // если выбран фильтр то фильтруем ещё и в соответствии с выбранным фильтром
        if let isCompletedTrackersFilterPicked {
            reloadVisibleCategoriesAfterPickingFilter(needToShowCompleted: isCompletedTrackersFilterPicked)
        }
        collectionView.reloadData()
        let hasVisible = !visibleCategories.isEmpty
        showPlaceholdersAndFiltersButtonIfNeeded(hasVisible)
    }
    
    private func reloadVisibleCategoriesAfterPickingFilter(needToShowCompleted: Bool) {
        let dateString = dateFormatter.string(from: currentDate)
        // фильтрация по дате из datePicker
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { $0.schedule.contains(dateString) }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: filteredTrackers)
        }
        // фильтрация по наличию записей в trackerRecord для текущей даты
        visibleCategories = visibleCategories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let (hasRecord, _) = checkTrackerRecord(id: tracker.id, date: currentDate)
                if needToShowCompleted {
                    return hasRecord
                } else {
                    return !hasRecord
                }
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: filteredTrackers)
        }
        collectionView.reloadData()
        let hasVisible = !visibleCategories.isEmpty
        showPlaceholdersAndFiltersButtonIfNeeded(hasVisible)
    }
    
    private func showPlaceholdersAndFiltersButtonIfNeeded(_ hasVisibleCategories: Bool) {
        let text = searchField.text ?? ""
        if text != "" && hasVisibleCategories {
            errorImage.isHidden = true
            textView.isHidden = true
            nothingFoundImage.isHidden = true
            nothingFoundLabel.isHidden = true
        } else if text != "" && !hasVisibleCategories {
            errorImage.isHidden = true
            textView.isHidden = true
            nothingFoundImage.isHidden = false
            nothingFoundLabel.isHidden = false
        } else if text == "" && !hasVisibleCategories {
            nothingFoundImage.isHidden = true
            nothingFoundLabel.isHidden = true
            errorImage.isHidden = false
            textView.isHidden = false
        } else if text == "" && hasVisibleCategories {
            errorImage.isHidden = true
            textView.isHidden = true
            nothingFoundImage.isHidden = true
            nothingFoundLabel.isHidden = true
        }
        if let isCompletedTrackersFilterPicked,
           !hasVisibleCategories {
            errorImage.isHidden = true
            textView.isHidden = true
            nothingFoundImage.isHidden = false
            nothingFoundLabel.isHidden = false
            filtersTextOnFiltersButton.textColor = .red
        } else if let isCompletedTrackersFilterPicked,
                  hasVisibleCategories {
            errorImage.isHidden = true
            textView.isHidden = true
            nothingFoundImage.isHidden = true
            nothingFoundLabel.isHidden = true
            filtersTextOnFiltersButton.textColor = .red
        } else if isCompletedTrackersFilterPicked == nil {
            filtersTextOnFiltersButton.textColor = .white
        }
        filtersButton.isHidden = !hasVisibleCategories
    }
    
    private func checkTrackerRecord(id: UUID, date: Date) -> (Bool, Int) {
        var isThereIsRecordOnThatDay: Bool = false
        for record in completedTrackers {
            if record.id == id && calendar.isDate(record.date, inSameDayAs: date) {
                isThereIsRecordOnThatDay = true
            }
        }
        var counterOfCompletedTrackers = 0
        for record in completedTrackers {
            if record.id == id {
                counterOfCompletedTrackers += 1
            }
        }
        return (isThereIsRecordOnThatDay, counterOfCompletedTrackers)
    }
    
    @objc private func plusButtonTapped() {
        let vc = NewHabitViewController()
        vc.delegate = self
        present(vc, animated: true)
        addTrackerButtonTappedReport()
    }
    
    @objc private func datePickerValueChanged() {
        currentDate = datePicker.date
        reloadVisibleCategories()
    }
    
    @objc private func searchFieldDidEndEditing() {
        reloadVisibleCategories()
    }
    
    @objc private func filtersButtonTapped() {
        let vc = TrackerFiltrationViewController()
        vc.delegate = self
        vc.isCompletedTrackersFilterPicked = isCompletedTrackersFilterPicked
        present(vc, animated: true)
        filtersButtonTappedReport()
    }
}


// MARK: CollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCell
        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        let recordTuple = checkTrackerRecord(id: visibleCategories[indexPath.section].trackers[indexPath.item].id, date: currentDate)
        cell.configureCell(
            task: visibleCategories[indexPath.section].trackers[indexPath.item].name,
            emoji: visibleCategories[indexPath.section].trackers[indexPath.item].emoji,
            color: UIColor(red: CGFloat(visibleCategories[indexPath.section].trackers[indexPath.item].redPartOfColor), green: CGFloat(visibleCategories[indexPath.section].trackers[indexPath.item].greenPartOfColor), blue: CGFloat(visibleCategories[indexPath.section].trackers[indexPath.item].bluePartOfColor), alpha: 1),
            id: visibleCategories[indexPath.section].trackers[indexPath.item].id,
            days: recordTuple.1,
            isDoneOnThatDay: recordTuple.0
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? TrackerHeader
        else {
            return UICollectionReusableView()
        }
        header.configureHeader(with: visibleCategories[indexPath.section].name)
        return header
    }
}


// MARK: setup view
private extension TrackerViewController {
    private func setupView() {
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .darkBackground
        } else {
            view.backgroundColor = .white
        }
        searchField.delegate = self
        setUpPlusButton(button: plusButton)
        setUpTrackersTextView(tv: trackersTextLabel)
        setUpSearchField(tf: searchField)
        setUpDatePicker(dp: datePicker)
        setUpCollectionView(cv: collectionView)
        setUpErrorImage(image: errorImage)
        setUpTextView(tv: textView)
        setUpNothingFoundImage()
        setUpNothingFoundLabel()
        setUpFiltersButton()
        setUpFiltersTextOnFiltersButton()
    }
    
    private func setUpPlusButton(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        if traitCollection.userInterfaceStyle == .dark {
            button.tintColor = .white
        } else {
            button.tintColor = .black
        }
    }
    
    private func setUpTrackersTextView(tv: UILabel) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tv)
        tv.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1).isActive = true
        tv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tv.widthAnchor.constraint(equalToConstant: 254).isActive = true
        tv.heightAnchor.constraint(equalToConstant: 41).isActive = true
        tv.text = NSLocalizedString("trackersLabelOnTrackersView", comment: "")
        tv.font = .systemFont(ofSize: 34, weight: .bold)
        tv.backgroundColor = .clear
        if traitCollection.userInterfaceStyle == .dark {
            tv.textColor = .white
        } else {
            tv.textColor = .black
        }
    }
    
    private func setUpSearchField(tf: UISearchTextField) {
        tf.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tf)
        tf.topAnchor.constraint(equalTo: trackersTextLabel.bottomAnchor, constant: 7).isActive = true
        tf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tf.heightAnchor.constraint(equalToConstant: 36).isActive = true
        tf.placeholder = NSLocalizedString("searchFieldPlaceholder", comment: "")
        tf.textColor = .ypGray
        tf.layer.cornerRadius = 10
        tf.layer.masksToBounds = true
        tf.addTarget(self, action: #selector(searchFieldDidEndEditing), for: .allEvents)
        if traitCollection.userInterfaceStyle == .dark {
            tf.backgroundColor = .darkSearchFieldBackground
        } else {
            tf.backgroundColor = .ypSearchField
        }
    }
    
    private func setUpDatePicker(dp: UIDatePicker) {
        dp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dp)
        dp.topAnchor.constraint(equalTo: view.topAnchor, constant: 49).isActive = true
        dp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .compact
        dp.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    private func setUpErrorImage(image: UIImageView) {
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        image.heightAnchor.constraint(equalToConstant: 80).isActive = true
        image.image = UIImage(named: "error")
    }
    
    private func setUpTextView(tv: UILabel) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tv)
        tv.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 8).isActive = true
        tv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tv.text = NSLocalizedString("whenNoTrackersPlaceholder", comment: "")
        tv.font = .systemFont(ofSize: 12, weight: .medium)
        if traitCollection.userInterfaceStyle == .dark {
            tv.textColor = .white
        } else {
            tv.textColor = .black
        }
    }
    
    private func setUpNothingFoundImage() {
        nothingFoundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nothingFoundImage)
        nothingFoundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330).isActive = true
        nothingFoundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nothingFoundImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nothingFoundImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        nothingFoundImage.image = UIImage(resource: .nothingFoundImagePlaceholder)
    }
    
    private func setUpNothingFoundLabel() {
        nothingFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nothingFoundLabel)
        nothingFoundLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 8).isActive = true
        nothingFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nothingFoundLabel.text = NSLocalizedString("nothingFound", comment: "")
        nothingFoundLabel.font = .systemFont(ofSize: 12, weight: .medium)
        if traitCollection.userInterfaceStyle == .dark {
            nothingFoundLabel.textColor = .white
        } else {
            nothingFoundLabel.textColor = .black
        }
    }
    
    private func setUpCollectionView(cv: UICollectionView) {
        cv.register(TrackerCell.self, forCellWithReuseIdentifier: "trackerCell")
        cv.register(TrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        cv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cv)
        cv.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 34).isActive = true
        cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        if traitCollection.userInterfaceStyle == .dark {
            cv.backgroundColor = .darkBackground
        } else {
            cv.backgroundColor = .white
        }
    }
    
    private func setUpFiltersButton() {
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersButton)
        NSLayoutConstraint.activate([
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        filtersButton.setImage(.filtersButton, for: .normal)
        filtersButton.tintColor = .ypBlue
        filtersButton.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
    }
    
    private func setUpFiltersTextOnFiltersButton() {
        filtersTextOnFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.addSubview(filtersTextOnFiltersButton)
        NSLayoutConstraint.activate([
            filtersTextOnFiltersButton.centerXAnchor.constraint(equalTo: filtersButton.centerXAnchor),
            filtersTextOnFiltersButton.centerYAnchor.constraint(equalTo: filtersButton.centerYAnchor)
        ])
        filtersTextOnFiltersButton.font = .systemFont(ofSize: 17, weight: .regular)
        filtersTextOnFiltersButton.textColor = .white
        filtersTextOnFiltersButton.text = NSLocalizedString("filtersButton", comment: "")
    }
}


// MARK: реализация темной и светлой тем
extension TrackerViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *),
           traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if traitCollection.userInterfaceStyle == .dark {
                trackersTextLabel.textColor = .white
                view.backgroundColor = .darkBackground
                collectionView.backgroundColor = .darkBackground
                searchField.backgroundColor = .darkSearchFieldBackground
                plusButton.tintColor = .white
            } else {
                trackersTextLabel.textColor = .black
                view.backgroundColor = .white
                collectionView.backgroundColor = .white
                searchField.backgroundColor = .ypSearchField
                plusButton.tintColor = .black
            }
        }
    }
}


// MARK: реализация аналитики (отправка событий через AppMetrica)
extension TrackerViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsManager.reportEvent(eventName: AnalyticsParametersEvent.open, onScreen: AnalyticsParametersScreen.main, triggeredItem: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsManager.reportEvent(eventName: AnalyticsParametersEvent.close, onScreen: AnalyticsParametersScreen.main, triggeredItem: nil)
    }
    
    private func addTrackerButtonTappedReport() {
        AnalyticsManager.reportEvent(eventName: AnalyticsParametersEvent.click, onScreen: AnalyticsParametersScreen.main, triggeredItem: AnalyticsParametersItem.addTrackerButtonTapped)
    }
    
    private func filtersButtonTappedReport() {
        AnalyticsManager.reportEvent(eventName: AnalyticsParametersEvent.click, onScreen: AnalyticsParametersScreen.main, triggeredItem: AnalyticsParametersItem.filterButtonTapped)
    }
}
