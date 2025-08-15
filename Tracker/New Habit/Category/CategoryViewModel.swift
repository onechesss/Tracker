//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by oneche$$$ on 08.08.2025.
//

import Foundation

final class CategoryViewModel {
    var model: CategoryModel
    var previousPickedCellIndexPath: IndexPath?
    var pickedCategoryIndexPath: IndexPath?
    var changeSelectionStateInTableView: (() -> Void)
    var reloadTableView: (() -> Void)
    var categories: [TrackerCategory] {
        model.categories
    }
    
    init(model: CategoryModel, previousPickedCellIndexPath: IndexPath? = nil, pickedCategoryIndexPath: IndexPath? = nil, changeSelectionStateInTableView: @escaping () -> Void) {
        self.model = model
        self.previousPickedCellIndexPath = previousPickedCellIndexPath
        self.pickedCategoryIndexPath = pickedCategoryIndexPath
        self.changeSelectionStateInTableView = changeSelectionStateInTableView
        self.reloadTableView = { }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("CategoriesChangedInModel"), object: nil, queue: .main) { _ in
            self.reloadTableView()
        }
    }
    
    func tableViewCellSelected(at index: Int, indexPath: IndexPath) {
        model.chosenCategory = categories[index].name
        pickedCategoryIndexPath = indexPath
        changeSelectionStateInTableView()
        previousPickedCellIndexPath = indexPath
    }
}
