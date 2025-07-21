//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 18.07.2025.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func weekdaysWereChosen(weekdaysDictionary: [String: Bool])
}

final class ScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let scheduleLabel = UILabel()
    private let mondayToggle = UISwitch()
    private let tuesdayToggle = UISwitch()
    private let wednesdayToggle = UISwitch()
    private let thursdayToggle = UISwitch()
    private let fridayToggle = UISwitch()
    private let saturdayToggle = UISwitch()
    private let sundayToggle = UISwitch()
    private let readyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let weekdaysDictionary = ["Пн": mondayToggle.isOn,
                                  "Вт": tuesdayToggle.isOn,
                                  "Ср": wednesdayToggle.isOn,
                                  "Чт": thursdayToggle.isOn,
                                  "Пт": fridayToggle.isOn,
                                  "Сб": saturdayToggle.isOn,
                                  "Вс": sundayToggle.isOn]
        delegate?.weekdaysWereChosen(weekdaysDictionary: weekdaysDictionary)
    }

    @objc private func readyButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: setup view
private extension ScheduleViewController {
    private func setupView() {
        view.backgroundColor = .white
        setUpScheduleLabel()
        setUpMondayView()
        setUpTuesdayView()
        setUpWednesdayView()
        setUpThursdayView()
        setUpFridayView()
        setUpSaturdayView()
        setUpSundayView()
        setUpReadyButton()
    }
    
    private func setUpScheduleLabel() {
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scheduleLabel)
        scheduleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scheduleLabel.widthAnchor.constraint(equalToConstant: 133).isActive = true
        scheduleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        scheduleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        scheduleLabel.text = "Расписание"
        scheduleLabel.textColor = .black
        scheduleLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func setUpMondayView() {
        let mondayView = UIView()
        mondayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mondayView)
        mondayView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        mondayView.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 30).isActive = true
        mondayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mondayView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        mondayView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        mondayView.layer.masksToBounds = true
        mondayView.layer.cornerRadius = 16
        mondayView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let textInButton = UILabel()
        textInButton.translatesAutoresizingMaskIntoConstraints = false
        mondayView.addSubview(textInButton)
        textInButton.text = "Понедельник"
        textInButton.font = .systemFont(ofSize: 17, weight: .regular)
        textInButton.textColor = .black
        textInButton.leadingAnchor.constraint(equalTo: mondayView.leadingAnchor, constant: 16).isActive = true
        textInButton.topAnchor.constraint(equalTo: mondayView.topAnchor, constant: 27).isActive = true
        let dividerImage = UIImageView()
        dividerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.topAnchor.constraint(equalTo: mondayView.bottomAnchor).isActive = true
        dividerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mondayView.addSubview(mondayToggle)
        mondayToggle.translatesAutoresizingMaskIntoConstraints = false
        mondayToggle.trailingAnchor.constraint(equalTo: mondayView.trailingAnchor, constant: -16).isActive = true
        mondayToggle.topAnchor.constraint(equalTo: mondayView.topAnchor, constant: 22).isActive = true
        mondayToggle.onTintColor = .ypBlue
    }
    
    private func setUpTuesdayView() {
        let tuesdayView = UIView()
        tuesdayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tuesdayView)
        tuesdayView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        tuesdayView.topAnchor.constraint(equalTo: mondayToggle.bottomAnchor, constant: 22).isActive = true
        tuesdayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tuesdayView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        tuesdayView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        let textInButton = UILabel()
        textInButton.translatesAutoresizingMaskIntoConstraints = false
        tuesdayView.addSubview(textInButton)
        textInButton.text = "Вторник"
        textInButton.font = .systemFont(ofSize: 17, weight: .regular)
        textInButton.textColor = .black
        textInButton.leadingAnchor.constraint(equalTo: tuesdayView.leadingAnchor, constant: 16).isActive = true
        textInButton.topAnchor.constraint(equalTo: tuesdayView.topAnchor, constant: 27).isActive = true
        let dividerImage = UIImageView()
        dividerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.topAnchor.constraint(equalTo: tuesdayView.bottomAnchor).isActive = true
        dividerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tuesdayView.addSubview(tuesdayToggle)
        tuesdayToggle.translatesAutoresizingMaskIntoConstraints = false
        tuesdayToggle.trailingAnchor.constraint(equalTo: tuesdayView.trailingAnchor, constant: -16).isActive = true
        tuesdayToggle.topAnchor.constraint(equalTo: tuesdayView.topAnchor, constant: 22).isActive = true
        tuesdayToggle.onTintColor = .ypBlue
    }
    
    private func setUpWednesdayView() {
        let wednesdayView = UIView()
        wednesdayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wednesdayView)
        wednesdayView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        wednesdayView.topAnchor.constraint(equalTo: tuesdayToggle.bottomAnchor, constant: 22).isActive = true
        wednesdayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wednesdayView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        wednesdayView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        let textInButton = UILabel()
        textInButton.translatesAutoresizingMaskIntoConstraints = false
        wednesdayView.addSubview(textInButton)
        textInButton.text = "Среда"
        textInButton.font = .systemFont(ofSize: 17, weight: .regular)
        textInButton.textColor = .black
        textInButton.leadingAnchor.constraint(equalTo: wednesdayView.leadingAnchor, constant: 16).isActive = true
        textInButton.topAnchor.constraint(equalTo: wednesdayView.topAnchor, constant: 27).isActive = true
        let dividerImage = UIImageView()
        dividerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.topAnchor.constraint(equalTo: wednesdayView.bottomAnchor).isActive = true
        dividerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wednesdayView.addSubview(wednesdayToggle)
        wednesdayToggle.translatesAutoresizingMaskIntoConstraints = false
        wednesdayToggle.trailingAnchor.constraint(equalTo: wednesdayView.trailingAnchor, constant: -16).isActive = true
        wednesdayToggle.topAnchor.constraint(equalTo: wednesdayView.topAnchor, constant: 22).isActive = true
        wednesdayToggle.onTintColor = .ypBlue
    }
    
    private func setUpThursdayView() {
        let thursdayView = UIView()
        thursdayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thursdayView)
        thursdayView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        thursdayView.topAnchor.constraint(equalTo: wednesdayToggle.bottomAnchor, constant: 22).isActive = true
        thursdayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thursdayView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        thursdayView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        let textInButton = UILabel()
        textInButton.translatesAutoresizingMaskIntoConstraints = false
        thursdayView.addSubview(textInButton)
        textInButton.text = "Четверг"
        textInButton.font = .systemFont(ofSize: 17, weight: .regular)
        textInButton.textColor = .black
        textInButton.leadingAnchor.constraint(equalTo: thursdayView.leadingAnchor, constant: 16).isActive = true
        textInButton.topAnchor.constraint(equalTo: thursdayView.topAnchor, constant: 27).isActive = true
        let dividerImage = UIImageView()
        dividerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.topAnchor.constraint(equalTo: thursdayView.bottomAnchor).isActive = true
        dividerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thursdayView.addSubview(thursdayToggle)
        thursdayToggle.translatesAutoresizingMaskIntoConstraints = false
        thursdayToggle.trailingAnchor.constraint(equalTo: thursdayView.trailingAnchor, constant: -16).isActive = true
        thursdayToggle.topAnchor.constraint(equalTo: thursdayView.topAnchor, constant: 22).isActive = true
        thursdayToggle.onTintColor = .ypBlue
    }
    
    private func setUpFridayView() {
        let fridayView = UIView()
        fridayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fridayView)
        fridayView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        fridayView.topAnchor.constraint(equalTo: thursdayToggle.bottomAnchor, constant: 22).isActive = true
        fridayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fridayView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        fridayView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        let textInButton = UILabel()
        textInButton.translatesAutoresizingMaskIntoConstraints = false
        fridayView.addSubview(textInButton)
        textInButton.text = "Пятница"
        textInButton.font = .systemFont(ofSize: 17, weight: .regular)
        textInButton.textColor = .black
        textInButton.leadingAnchor.constraint(equalTo: fridayView.leadingAnchor, constant: 16).isActive = true
        textInButton.topAnchor.constraint(equalTo: fridayView.topAnchor, constant: 27).isActive = true
        let dividerImage = UIImageView()
        dividerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.topAnchor.constraint(equalTo: fridayView.bottomAnchor).isActive = true
        dividerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fridayView.addSubview(fridayToggle)
        fridayToggle.translatesAutoresizingMaskIntoConstraints = false
        fridayToggle.trailingAnchor.constraint(equalTo: fridayView.trailingAnchor, constant: -16).isActive = true
        fridayToggle.topAnchor.constraint(equalTo: fridayView.topAnchor, constant: 22).isActive = true
        fridayToggle.onTintColor = .ypBlue
    }
    
    private func setUpSaturdayView() {
        let saturdayView = UIView()
        saturdayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saturdayView)
        saturdayView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        saturdayView.topAnchor.constraint(equalTo: fridayToggle.bottomAnchor, constant: 22).isActive = true
        saturdayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saturdayView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        saturdayView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        let textInButton = UILabel()
        textInButton.translatesAutoresizingMaskIntoConstraints = false
        saturdayView.addSubview(textInButton)
        textInButton.text = "Суббота"
        textInButton.font = .systemFont(ofSize: 17, weight: .regular)
        textInButton.textColor = .black
        textInButton.leadingAnchor.constraint(equalTo: saturdayView.leadingAnchor, constant: 16).isActive = true
        textInButton.topAnchor.constraint(equalTo: saturdayView.topAnchor, constant: 27).isActive = true
        let dividerImage = UIImageView()
        dividerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.topAnchor.constraint(equalTo: saturdayView.bottomAnchor).isActive = true
        dividerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saturdayView.addSubview(saturdayToggle)
        saturdayToggle.translatesAutoresizingMaskIntoConstraints = false
        saturdayToggle
            .trailingAnchor.constraint(equalTo: saturdayView.trailingAnchor, constant: -16).isActive = true
        saturdayToggle.topAnchor.constraint(equalTo: saturdayView.topAnchor, constant: 22).isActive = true
        saturdayToggle.onTintColor = .ypBlue
    }
    
    private func setUpSundayView() {
        let sundayView = UIView()
        sundayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sundayView)
        sundayView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        sundayView.topAnchor.constraint(equalTo: saturdayToggle.bottomAnchor, constant: 22).isActive = true
        sundayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sundayView.widthAnchor.constraint(equalToConstant: 343).isActive = true
        sundayView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        sundayView.layer.masksToBounds = true
        sundayView.layer.cornerRadius = 16
        sundayView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let textInButton = UILabel()
        textInButton.translatesAutoresizingMaskIntoConstraints = false
        sundayView.addSubview(textInButton)
        textInButton.text = "Воскресенье"
        textInButton.font = .systemFont(ofSize: 17, weight: .regular)
        textInButton.textColor = .black
        textInButton.leadingAnchor.constraint(equalTo: sundayView.leadingAnchor, constant: 16).isActive = true
        textInButton.topAnchor.constraint(equalTo: sundayView.topAnchor, constant: 27).isActive = true
        let dividerImage = UIImageView()
        dividerImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerImage)
        dividerImage.image = UIImage(named: "divider")
        dividerImage.topAnchor.constraint(equalTo: sundayView.bottomAnchor).isActive = true
        dividerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sundayView.addSubview(sundayToggle)
        sundayToggle.translatesAutoresizingMaskIntoConstraints = false
        sundayToggle
            .trailingAnchor.constraint(equalTo: sundayView.trailingAnchor, constant: -16).isActive = true
        sundayToggle.topAnchor.constraint(equalTo: sundayView.topAnchor, constant: 22).isActive = true
        sundayToggle.onTintColor = .ypBlue
    }
    
    private func setUpReadyButton() {
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readyButton)
        readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        readyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        readyButton.widthAnchor.constraint(equalToConstant: 335).isActive = true
        readyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        readyButton.setImage(.readyButton, for: .normal)
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
    }
}

#Preview {
    ScheduleViewController()
}
