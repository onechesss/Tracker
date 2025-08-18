//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 22.06.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private var model: StatisticsModel
    
    private let statisticsLabel = UILabel()
    private let bestPeriodFrame = UIImageView()
    private let bestPeriodValueLabel = UILabel()
    private let bestPeriodLabel = UILabel()
    private let idealDaysFrame = UIImageView()
    private let idealDaysValueLabel = UILabel()
    private let idealDaysLabel = UILabel()
    private let trackersDoneFrame = UIImageView()
    private let trackersDoneValueLabel = UILabel()
    private let trackersDoneLabel = UILabel()
    private let meanValueFrame = UIImageView()
    private let meanValueValueLabel = UILabel()
    private let meanValueLabel = UILabel()
    private let nothingToAnalyzeImage = UIImageView()
    private let nothingToAnalyzeLabel = UILabel()
    
    init(model: StatisticsModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bestPeriodValueLabel.text = model.getBestPeriod()
        idealDaysValueLabel.text = model.getIdealDays()
        trackersDoneValueLabel.text = model.getHowManyTrackersDoneEver()
        meanValueValueLabel.text = model.getMeanValueOfDoneTrackers()
    }
    
    func bind(model: StatisticsModel) {
        self.model = model
        bestPeriodValueLabel.text = model.getBestPeriod()
        idealDaysValueLabel.text = model.getIdealDays()
        trackersDoneValueLabel.text = model.getHowManyTrackersDoneEver()
        meanValueValueLabel.text = model.getMeanValueOfDoneTrackers()
    }
}


// MARK: setup view
private extension StatisticsViewController {
    private func setupView() {
        view.backgroundColor = .white
        setUpStatisticsLabel()
        setUpBestPeriodFrame()
        setUpBestPeriodValueLabel()
        setUpBestPeriodLabel()
        setUpIdealDaysFrame()
        setUpIdealDaysValueLabel()
        setUpIdealDaysLabel()
        setUpTrackersDoneFrame()
        setUpTrackersDoneValueLabel()
        setUpTrackersDoneLabel()
        setUpMeanValueFrame()
        setUpMeanValueValueLabel()
        setUpMeanValueLabel()
    }
    
    private func setUpStatisticsLabel() {
        statisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statisticsLabel)
        NSLayoutConstraint.activate([
            statisticsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            statisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        statisticsLabel.text = "Статистика"
        statisticsLabel.font = .systemFont(ofSize: 34, weight: .bold)
        statisticsLabel.textColor = .black
        statisticsLabel.textAlignment = .left
    }
    
    private func setUpBestPeriodFrame() {
        bestPeriodFrame.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestPeriodFrame)
        NSLayoutConstraint.activate([
            bestPeriodFrame.topAnchor.constraint(equalTo: statisticsLabel.bottomAnchor, constant: 77),
            bestPeriodFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        bestPeriodFrame.image = .gradientBorder
        let whiteRect = UIView()
        whiteRect.translatesAutoresizingMaskIntoConstraints = false
        whiteRect.frame = CGRect(x: 3, y: 10, width: 150, height: 70)
        whiteRect.backgroundColor = .white
        bestPeriodFrame.addSubview(whiteRect)
    }
    
    private func setUpBestPeriodValueLabel() {
        bestPeriodValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestPeriodValueLabel)
        NSLayoutConstraint.activate([
            bestPeriodValueLabel.topAnchor.constraint(equalTo: bestPeriodFrame.topAnchor, constant: 12),
            bestPeriodValueLabel.leadingAnchor.constraint(equalTo: bestPeriodFrame.leadingAnchor, constant: 12)
        ])
        bestPeriodValueLabel.textColor = .black
        bestPeriodValueLabel.font = .systemFont(ofSize: 34, weight: .bold)
    }
    
    private func setUpBestPeriodLabel() {
        bestPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bestPeriodLabel)
        NSLayoutConstraint.activate([
            bestPeriodLabel.bottomAnchor.constraint(equalTo: bestPeriodFrame.bottomAnchor, constant: -12),
            bestPeriodLabel.leadingAnchor.constraint(equalTo: bestPeriodFrame.leadingAnchor, constant: 12)
        ])
        bestPeriodLabel.text = "Лучший период"
        bestPeriodLabel.font = .systemFont(ofSize: 12, weight: .medium)
        bestPeriodLabel.textColor = .black
    }
    
    private func setUpIdealDaysFrame() {
        idealDaysFrame.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idealDaysFrame)
        NSLayoutConstraint.activate([
            idealDaysFrame.topAnchor.constraint(equalTo: bestPeriodFrame.bottomAnchor, constant: 12),
            idealDaysFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        idealDaysFrame.image = .gradientBorder
        let whiteRect = UIView()
        whiteRect.translatesAutoresizingMaskIntoConstraints = false
        whiteRect.frame = CGRect(x: 3, y: 10, width: 150, height: 70)
        whiteRect.backgroundColor = .white
        idealDaysFrame.addSubview(whiteRect)
    }
    
    private func setUpIdealDaysValueLabel() {
        idealDaysValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idealDaysValueLabel)
        NSLayoutConstraint.activate([
            idealDaysValueLabel.topAnchor.constraint(equalTo: idealDaysFrame.topAnchor, constant: 12),
            idealDaysValueLabel.leadingAnchor.constraint(equalTo: idealDaysFrame.leadingAnchor, constant: 12)
        ])
        idealDaysValueLabel.textColor = .black
        idealDaysValueLabel.font = .systemFont(ofSize: 34, weight: .bold)
    }
    
    private func setUpIdealDaysLabel() {
        idealDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idealDaysLabel)
        NSLayoutConstraint.activate([
            idealDaysLabel.bottomAnchor.constraint(equalTo: idealDaysFrame.bottomAnchor, constant: -12),
            idealDaysLabel.leadingAnchor.constraint(equalTo: idealDaysFrame.leadingAnchor, constant: 12)
        ])
        idealDaysLabel.text = "Идеальные дни"
        idealDaysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        idealDaysLabel.textColor = .black
    }
    
    private func setUpTrackersDoneFrame() {
        trackersDoneFrame.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersDoneFrame)
        NSLayoutConstraint.activate([
            trackersDoneFrame.topAnchor.constraint(equalTo: idealDaysFrame.bottomAnchor, constant: 12),
            trackersDoneFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        trackersDoneFrame.image = .gradientBorder
        let whiteRect = UIView()
        whiteRect.translatesAutoresizingMaskIntoConstraints = false
        whiteRect.frame = CGRect(x: 3, y: 10, width: 150, height: 70)
        whiteRect.backgroundColor = .white
        trackersDoneFrame.addSubview(whiteRect)
    }
    
    private func setUpTrackersDoneValueLabel() {
        trackersDoneValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersDoneValueLabel)
        NSLayoutConstraint.activate([
            trackersDoneValueLabel.topAnchor.constraint(equalTo: trackersDoneFrame.topAnchor, constant: 12),
            trackersDoneValueLabel.leadingAnchor.constraint(equalTo: trackersDoneFrame.leadingAnchor, constant: 12)
        ])
        trackersDoneValueLabel.textColor = .black
        trackersDoneValueLabel.font = .systemFont(ofSize: 34, weight: .bold)
    }
    
    private func setUpTrackersDoneLabel() {
        trackersDoneLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersDoneLabel)
        NSLayoutConstraint.activate([
            trackersDoneLabel.bottomAnchor.constraint(equalTo: trackersDoneFrame.bottomAnchor, constant: -12),
            trackersDoneLabel.leadingAnchor.constraint(equalTo: trackersDoneFrame.leadingAnchor, constant: 12)
        ])
        trackersDoneLabel.text = "Трекеров завершено"
        trackersDoneLabel.font = .systemFont(ofSize: 12, weight: .medium)
        trackersDoneLabel.textColor = .black
    }
    
    private func setUpMeanValueFrame() {
        meanValueFrame.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(meanValueFrame)
        NSLayoutConstraint.activate([
            meanValueFrame.topAnchor.constraint(equalTo: trackersDoneFrame.bottomAnchor, constant: 12),
            meanValueFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        meanValueFrame.image = .gradientBorder
        let whiteRect = UIView()
        whiteRect.translatesAutoresizingMaskIntoConstraints = false
        whiteRect.frame = CGRect(x: 3, y: 10, width: 150, height: 70)
        whiteRect.backgroundColor = .white
        meanValueFrame.addSubview(whiteRect)
    }
    
    private func setUpMeanValueValueLabel() {
        meanValueValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(meanValueValueLabel)
        NSLayoutConstraint.activate([
            meanValueValueLabel.topAnchor.constraint(equalTo: meanValueFrame.topAnchor, constant: 12),
            meanValueValueLabel.leadingAnchor.constraint(equalTo: meanValueFrame.leadingAnchor, constant: 12)
        ])
        meanValueValueLabel.textColor = .black
        meanValueValueLabel.font = .systemFont(ofSize: 34, weight: .bold)
    }
    
    private func setUpMeanValueLabel() {
        meanValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(meanValueLabel)
        NSLayoutConstraint.activate([
            meanValueLabel.bottomAnchor.constraint(equalTo: meanValueFrame.bottomAnchor, constant: -12),
            meanValueLabel.leadingAnchor.constraint(equalTo: meanValueFrame.leadingAnchor, constant: 12)
        ])
        meanValueLabel.text = "Среднее значение"
        meanValueLabel.font = .systemFont(ofSize: 12, weight: .medium)
        meanValueLabel.textColor = .black
    }
}
