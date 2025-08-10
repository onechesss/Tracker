//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 09.08.2025.
//

import UIKit

final class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    private let newCategoryLabel = UILabel()
    private let categoryNameTextField = UITextField()
    private let readyButton = UIButton()
    
    private var categoryModel: CategoryModel

    init(model: CategoryModel) {
        self.categoryModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        categoryNameTextField.delegate = self
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" && textField.text != nil {
            readyButton.isEnabled = true
        }
    }
    
    // MARK: UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func readyButtonTapped() {
        categoryModel.addCategoryToCoreData(category: categoryNameTextField.text ?? "")
        dismiss(animated: true)
    }
}


// MARK: setup view
extension NewCategoryViewController {
    private func setupView() {
        setUpNewCategoryLabel()
        setUpCategoryNameTextField()
        setUpReadyButton()
        view.backgroundColor = .white
    }
    
    private func setUpNewCategoryLabel() {
        newCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newCategoryLabel)
        NSLayoutConstraint.activate([
            newCategoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCategoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28)
        ])
        newCategoryLabel.text = "Новая категория"
        newCategoryLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newCategoryLabel.textColor = .black
    }
    
    private func setUpCategoryNameTextField() {
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryNameTextField)
        NSLayoutConstraint.activate([
            categoryNameTextField.widthAnchor.constraint(equalToConstant: 343),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryNameTextField.topAnchor.constraint(equalTo: newCategoryLabel.bottomAnchor, constant: 38),
            categoryNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        categoryNameTextField.borderStyle = .roundedRect
        categoryNameTextField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        categoryNameTextField.placeholder = "Введите название категории"
        categoryNameTextField.textColor = .black
        categoryNameTextField.layer.cornerRadius = 16
        categoryNameTextField.layer.masksToBounds = true
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1),
            .font: UIFont.systemFont(ofSize: 17, weight: .regular)
        ]
        categoryNameTextField.attributedPlaceholder = NSAttributedString(string: "Введите название категории", attributes: attributes)
    }
    
    private func setUpReadyButton() {
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readyButton)
        NSLayoutConstraint.activate([
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            readyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        readyButton.setImage(UIImage(resource: .readyButton), for: .normal)
        readyButton.setImage(UIImage(resource: .readyButtonDisabled), for: .disabled)
        readyButton.isEnabled = false
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
    }
}
