//
//  Tracker.swift
//  Tracker
//
//  Created by oneche$$$ on 22.06.2025.
//

import UIKit

final class TrackerViewController: UIViewController {
    private let imageView = UIImageView()
    private let textView = UITextView()
    private let searchField = UISearchTextField()
    private let trackersTextLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let plusButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
print("viewDidLoad")
        view.backgroundColor = .white
    }
}



// MARK: setup view
extension TrackerViewController {
    private func setupView() {
        setUpPlusButtonView(button: plusButton)
        setUpTrackersTextField(tv: trackersTextLabel)
        setUpSearchField(tf: searchField)
        setUpDatePicker(dp: datePicker)
    }
    
    private func setUpPlusButtonView(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        //button.imageView?.image = UIImage(named: "plus")
        button.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    private func setUpTrackersTextField(tv: UILabel) {
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
        tf.text = "Поиск"
        tf.layer.cornerRadius = 10
        tf.textColor = .ypGray
        tf.backgroundColor = .ypSearchField
    }
    
    private func setUpDatePicker(dp: UIDatePicker) {
        dp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dp)
        dp.topAnchor.constraint(equalTo: view.topAnchor, constant: 49).isActive = true
        dp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dp.datePickerMode = .date
        dp.tintColor = .black
        dp.setValue(UIColor.black, forKey: "textColor")
    }
}

