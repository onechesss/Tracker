//
//  CategoryViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 08.08.2025.
//

import UIKit

final class CategoryViewController: UIViewController {
    var viewModel: CategoryViewModel
    
    private let categoryLabel = UILabel()
    private let addCategoryButton = UIButton()
    private let categoriesTable = UITableView()
    private let placeholderImage = UIImageView()
    private let placeholderLabel = UILabel()
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
    }
    
    private func bind() {
        viewModel.changeSelectionStateInTableView = { [weak self] in
            guard let self else { return }
            if let actualIndexPath = self.viewModel.pickedCategoryIndexPath {
                let cell = self.categoriesTable.cellForRow(at: actualIndexPath) as? CategoryCell
                cell?.pickedCategoryImage.isHidden = false
            }
            if let previousIndexPath = viewModel.previousPickedCellIndexPath {
                let cell = self.categoriesTable.cellForRow(at: previousIndexPath) as? CategoryCell
                cell?.pickedCategoryImage.isHidden = true
            }
        }
        viewModel.reloadTableView = { [weak self] in
            guard let self else { return }
            self.hideTableViewAndShowPlaceholderIfNeeded()
            self.categoriesTable.reloadData()
        }
    }
    
    private func hideTableViewAndShowPlaceholderIfNeeded() {
        if viewModel.categories.count != 0 {
            placeholderLabel.isHidden = true
            placeholderImage.isHidden = true
            categoriesTable.isHidden = false
        } else {
            categoriesTable.isHidden = true
        }
    }
    
    @objc private func addCategoryButtonTapped() {
        let vc = NewCategoryViewController(model: viewModel.model)
        present(vc, animated: true)
    }
}


// MARK: Categories table view data source
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? CategoryCell else { return UITableViewCell() }
        cell.configure(with: viewModel.categories[indexPath.row].name)
        return cell
    }
}


// MARK: Categories table view delegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        viewModel.tableViewCellSelected(at: index, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: setup view
private extension CategoryViewController {
    private func setupView() {
        view.backgroundColor = .white
        setUpCategoryLabel()
        setUpAddCategoryButton()
        setUpCategoriesTable()
        setUpPlaceholderImage()
        setUpPlaceholderLabel()
        hideTableViewAndShowPlaceholderIfNeeded()
    }
    
    private func setUpCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryLabel)
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.widthAnchor.constraint(equalToConstant: 84).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.text = "Категория"
        categoryLabel.textColor = .black
        categoryLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func setUpAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addCategoryButton.widthAnchor.constraint(equalToConstant: 335).isActive = true
        addCategoryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addCategoryButton.setImage(.addCategoryButton, for: .normal)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
    }
    
    private func setUpCategoriesTable() {
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTable)
        NSLayoutConstraint.activate([
            categoriesTable.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 38),
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -114)
        ])
        categoriesTable.backgroundColor = UIColor(resource: .categoriesTableBackground)
        categoriesTable.layer.cornerRadius = 16
        categoriesTable.layer.masksToBounds = true
        categoriesTable.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
    }
    
    private func setUpPlaceholderImage() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderImage)
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -386)
        ])
        placeholderImage.image = UIImage(resource: .categoryPlaceholder)
    }
    
    private func setUpPlaceholderLabel() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        placeholderLabel.text = "Привычки и категории можно объединить по смыслу"
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.textColor = .black
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
    }
}
