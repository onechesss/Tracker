//
//  TrackerFiltrationViewController.swift
//  Tracker
//
//  Created by oneche$$$ on 16.08.2025.
//

import UIKit

protocol TrackersFiltrationDelegate: AnyObject {
    func didSelectFilter(_ filter: String)
}

final class TrackerFiltrationViewController: UIViewController {
    weak var delegate: TrackersFiltrationDelegate?
    var isCompletedTrackersFilterPicked: Bool?
    
    private let filtersLabel = UILabel()
    private let filtersTable = UITableView()
    
    private let filtersNames: [String] = ["Все трекеры", "Трекеры на сегодня", "Завершенные", "Не завершенные"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        filtersTable.delegate = self
        filtersTable.dataSource = self
    }
}

// MARK: Filters table view data source
extension TrackerFiltrationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? CategoryCell else { return UITableViewCell() }
        cell.configure(with: filtersNames[indexPath.row])
        if indexPath.row == 2,
           let isCompletedTrackersFilterPicked, isCompletedTrackersFilterPicked {
            cell.pickedCategoryImage.isHidden = false
        } else if indexPath.row == 3,
                  let isCompletedTrackersFilterPicked,
                  !isCompletedTrackersFilterPicked {
            cell.pickedCategoryImage.isHidden = false
        }
        return cell
    }
}


// MARK: Filters table view delegate
extension TrackerFiltrationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pickedCell = tableView.cellForRow(at: indexPath) as? CategoryCell
        else { return }
        if indexPath.row > 1 {
            pickedCell.pickedCategoryImage.isHidden = false
        }
        delegate?.didSelectFilter(filtersNames[indexPath.row])
        guard let cells = tableView.visibleCells as? [CategoryCell] else { return }
        for cell in cells {
            if cell !== pickedCell {
                cell.pickedCategoryImage.isHidden = true
            }
        }
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (filtersNames.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}


// MARK: setup view
private extension TrackerFiltrationViewController {
    private func setupView() {
        setUpFiltersLabel()
        setUpTableView()
        view.backgroundColor = .white
    }
    
    private func setUpFiltersLabel() {
        filtersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersLabel)
        filtersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filtersLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        filtersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28).isActive = true
        filtersLabel.text = "Новая привычка"
        filtersLabel.textColor = .black
        filtersLabel.font = .systemFont(ofSize: 16, weight: .medium)
        filtersLabel.textAlignment = .center
    }
    
    private func setUpTableView() {
        filtersTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersTable)
        NSLayoutConstraint.activate([
            filtersTable.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: 38),
            filtersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTable.heightAnchor.constraint(equalToConstant: 300)
        ])
        filtersTable.backgroundColor = UIColor(resource: .categoriesTableBackground)
        filtersTable.layer.cornerRadius = 16
        filtersTable.layer.masksToBounds = true
        filtersTable.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
        filtersTable.tableFooterView = UIView()
    }
}
