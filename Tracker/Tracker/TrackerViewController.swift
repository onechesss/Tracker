//
//  Tracker.swift
//  Tracker
//
//  Created by oneche$$$ on 22.06.2025.
//

import UIKit

final class TrackerViewController: UIViewController, UITextFieldDelegate, NewHabitViewControllerDelegate, TrackerCellDelegate {
    var currentDate = Date()
    
    private let errorImage = UIImageView()
    private let textView = UILabel()
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
        layout.sectionInset = .init(top: 30, left: 0, bottom: 0, right: 0)
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
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    
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
            categories[index] = categories[index].addNewTracker(Tracker: Tracker(
                id: id,
                name: name,
                redPartOfColor: Float(color.cgColor.components?[0] ?? 0),
                greenPartOfColor: Float(color.cgColor.components?[1] ?? 0),
                bluePartOfColor: Float(color.cgColor.components?[2] ?? 0),
                emoji: emoji,
                schedule: schedule)
            )
            trackerStore.addTrackerToCoreData(tracker: Tracker(
                id: id,
                name: name,
                redPartOfColor: Float(color.cgColor.components?[0] ?? 0),
                greenPartOfColor: Float(color.cgColor.components?[1] ?? 0),
                bluePartOfColor: Float(color.cgColor.components?[2] ?? 0),
                emoji: emoji,
                schedule: schedule), in: categories[index], with: categories[index].trackers)
            trackerCategoryStore.addTrackerToCategoryCoreData(category: categories[index], tracker: Tracker(id: id, name: name, redPartOfColor: Float(color.cgColor.components?[0] ?? 0), greenPartOfColor: Float(color.cgColor.components?[1] ?? 0), bluePartOfColor: Float(color.cgColor.components?[2] ?? 0), emoji: emoji, schedule: schedule))
        } else {
            categories.append(TrackerCategory(name: category, trackers: [Tracker(id: id, name: name, redPartOfColor: Float(color.cgColor.components?[0] ?? 0), greenPartOfColor: Float(color.cgColor.components?[1] ?? 0), bluePartOfColor: Float(color.cgColor.components?[2] ?? 0), emoji: emoji, schedule: schedule)]))
            let fetchedCategories = trackerCategoryStore.getCategoriesFromCoreData()
            for element in fetchedCategories {
                if element.name == category {
                    trackerCategoryStore.addTrackerToCategoryCoreData(category: element, tracker: Tracker(id: id, name: name, redPartOfColor: Float(color.cgColor.components?[0] ?? 0), greenPartOfColor: Float(color.cgColor.components?[1] ?? 0), bluePartOfColor: Float(color.cgColor.components?[2] ?? 0), emoji: emoji, schedule: schedule))
                }
            }
        }
        reloadVisibleCategories()
    }
    
    func plusButtonInCellSelected(in cell: TrackerCell) {
        trackerRecordStore.addTrackerRecordToCoreData(record: TrackerRecord(id: cell.id, date: currentDate))
        completedTrackers = trackerRecordStore.getTrackerRecordsFromCoreData()
    }
    
    func plusButtonInCellDeselected(in cell: TrackerCell) {
        trackerRecordStore.deleteTrackerRecordInCoreData(record: TrackerRecord(id: cell.id, date: currentDate))
        completedTrackers = trackerRecordStore.getTrackerRecordsFromCoreData()
    }
    
    private func reloadVisibleCategories() {
        let dateString = dateFormatter.string(from: currentDate)
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { $0.schedule.contains(dateString) }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: filteredTrackers)
        }
        collectionView.reloadData()
        let hasVisible = !visibleCategories.isEmpty
        errorImage.isHidden = hasVisible
        textView.isHidden = hasVisible
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
    }
    
    @objc private func datePickerValueChanged() {
        currentDate = datePicker.date
        reloadVisibleCategories()
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
        cell.backgroundColor = .white
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
        view.backgroundColor = .white
        searchField.delegate = self
        setUpPlusButton(button: plusButton)
        setUpTrackersTextView(tv: trackersTextLabel)
        setUpSearchField(tf: searchField)
        setUpDatePicker(dp: datePicker)
        setUpCollectionView(cv: collectionView)
        setUpErrorImage(image: errorImage)
        setUpTextView(tv: textView)
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
    }
    
    private func setUpTrackersTextView(tv: UILabel) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tv)
        tv.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1).isActive = true
        tv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tv.widthAnchor.constraint(equalToConstant: 254).isActive = true
        tv.heightAnchor.constraint(equalToConstant: 41).isActive = true
        tv.text = "Трекеры"
        tv.textColor = .black
        tv.font = .systemFont(ofSize: 34, weight: .bold)
    }
    
    private func setUpSearchField(tf: UISearchTextField) {
        tf.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tf)
        tf.topAnchor.constraint(equalTo: trackersTextLabel.bottomAnchor, constant: 7).isActive = true
        tf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tf.heightAnchor.constraint(equalToConstant: 36).isActive = true
        tf.placeholder = "Поиск"
        tf.textColor = .ypGray
        tf.backgroundColor = UIColor(named: "YP search field color")
        tf.layer.cornerRadius = 10
        tf.layer.masksToBounds = true
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
        tv.text = "Что будем отслеживать?"
        tv.font = .systemFont(ofSize: 12, weight: .medium)
        tv.textColor = .black
    }
    
    private func setUpCollectionView(cv: UICollectionView) {
        cv.register(TrackerCell.self, forCellWithReuseIdentifier: "trackerCell")
        cv.register(TrackerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        cv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cv)
        cv.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 34).isActive = true
        cv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        cv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        cv.backgroundColor = .white
    }
}
