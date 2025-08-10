//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by oneche$$$ on 08.08.2025.
//

import Foundation

struct CategoryViewModel {
    var model: CategoryModel
    var passCategoriesToView: (([String]) -> Void) = { _ in }
    
    func passCategoriesFromModelToView() {
        let namesOfCategories: [String] = model.categories.map(\.name)
        passCategoriesToView(namesOfCategories)
    }
}
