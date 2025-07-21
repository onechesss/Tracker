//
//  Tracker.swift
//  Tracker
//
//  Created by oneche$$$ on 22.06.2025.
//

import UIKit

final class TrackerViewController: UIViewController, UITextFieldDelegate, NewHabitViewControllerDelegate, TrackerCellDelegate {
    private let errorImage = UIImageView()
    private let textView = UILabel()
    private let searchField = UISearchTextField()
    private let trackersTextLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let plusButton = UIButton()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 167, height: 148)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 200, height: 6)
        layout.sectionInset = .init(top: 30, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    private var categories: [TrackerCategory] = [TrackerCategory(name: "Мок-категория", trackers: [])] // временно (в рамках спринта 14)
    private var completedTrackers: [TrackerRecord] = []
    
    private var idCounter: UInt = 0 // в будущих спринтах будет реализовано с помощью баз данных, userDefaults или keychain (чтобы при перезапуске приложения не создавались трекеры с уже используемыми id)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: NewHabitViewControllerDelegate method
    func didCreateNewHabit(name: String, categorie: String, schedule: String) {
        if let index = categories.firstIndex(where: { $0.name == categorie }) {
            categories[index].trackers.append(Tracker(id: idCounter, name: name, color: .ypGreen, emoji: "😁", schedule: schedule))
        }
        idCounter += 1
        collectionView.reloadData()
        textView.isHidden = true // временно (в рамках спринта 14)
        errorImage.isHidden = true // временно (в рамках спринта 14)
    }
    
    func plusButtonInCellSelected(in cell: TrackerCell) {
        completedTrackers.append(TrackerRecord(id: cell.id, date: datePicker.date))
    }
    
    func plusButtonInCellDeselected(in cell: TrackerCell) {
        if let index = completedTrackers.firstIndex(where: { $0.id == cell.id }) {
            completedTrackers.remove(at: index)
        }
    }

    @objc private func plusButtonTapped() {
        let vc = NewHabitViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
}


// MARK: CollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCell
        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.backgroundColor = .white
        cell.configureCell(
            task: categories[indexPath.section].trackers[indexPath.row].name,
            emoji: categories[indexPath.section].trackers[indexPath.row].emoji,
            color: categories[indexPath.section].trackers[indexPath.row].color,
            id: categories[indexPath.section].trackers[indexPath.row].id
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? TrackerHeader
        else {
            return UICollectionReusableView()
        }
        header.configureHeader(with: categories[indexPath.section].name)
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
        cv.dataSource = self
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

