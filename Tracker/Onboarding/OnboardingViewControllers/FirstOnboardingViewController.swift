//
//  FirstOnboardingViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 07.08.2025.
//

import UIKit

final class FirstOnboardingViewController: UIViewController {

    private let backgroundImageView = UIImageView()
    private let continueButton = UIButton()
    private let onboardingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func continueButtonTapped() {
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")
        if let window = UIApplication.shared.windows.first {
            let tabBarController = TabBarController()
            window.rootViewController = tabBarController
        }
        dismiss(animated: true)
    }
}


// MARK: setup view
private extension FirstOnboardingViewController {
    private func setupView() {
        setUpBackgroundImageView()
        setUpContinueButton()
        setUpOnboardingLabel()
    }
    
    private func setUpBackgroundImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        backgroundImageView.image = UIImage(resource: .firstOnboardingBackground)
    }
    
    private func setUpContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84)
        ])
        continueButton.setImage(UIImage(resource: .onboardingButton), for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func setUpOnboardingLabel() {
        onboardingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboardingLabel)
        onboardingLabel.font = .systemFont(ofSize: 32, weight: .bold)
        onboardingLabel.text = "Отслеживайте только то, что хотите"
        onboardingLabel.textColor = .black
        onboardingLabel.numberOfLines = 2
        onboardingLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            onboardingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            onboardingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
