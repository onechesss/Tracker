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
    
    private var categories = [String]()
    private var previousPickedCellIndexPath: IndexPath?
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        self.viewModel.passCategoriesFromModelToView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name("CategoriesChangedInModel"), object: nil, queue: .main) { [weak self] _ in
            self?.viewModel.passCategoriesFromModelToView()
            self?.categoriesTable.reloadData()
        }
    }
    
    private func bind() {
        viewModel.passCategoriesToView = { [weak self] categories in
                self?.categories = categories
                self?.categoriesTable.reloadData()
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
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        return cellForRow(at: indexPath) 
    }
}


// MARK: Categories table view delegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.model.chosenCategory = categories[indexPath.row]
        if let previousPickedCellIndexPath {
            let previousPickedCell = tableView.cellForRow(at: previousPickedCellIndexPath)
            guard let previousSubviews = previousPickedCell?.contentView.subviews else { return }
            for subview in previousSubviews {
                if let pickedCategoryImage = subview as? UIImageView {
                    pickedCategoryImage.isHidden = true
                }
            }
        }
        let cell = tableView.cellForRow(at: indexPath)
        guard let subviews = cell?.contentView.subviews else { return }
        for subview in subviews {
            if let pickedCategoryImage = subview as? UIImageView {
                pickedCategoryImage.isHidden = false
            }
        }
        previousPickedCellIndexPath = indexPath
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
        if categories.count != 0 {
            placeholderLabel.isHidden = true
            placeholderImage.isHidden = true
        } else {
            categoriesTable.isHidden = true
        }
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
    }
    
    // MARK: метод подготовки ячейки для таблицы категорий
    private func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(resource: .categoriesTableBackground)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.selectionStyle = .none
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16)
        ])
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.text = categories[indexPath.row]
        let pickedCategoryImage = UIImageView()
        pickedCategoryImage.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(pickedCategoryImage)
        NSLayoutConstraint.activate([
            pickedCategoryImage.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            pickedCategoryImage.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16)
        ])
        pickedCategoryImage.image = UIImage(resource: .pickedCategory)
        pickedCategoryImage.isHidden = true
        return cell
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
