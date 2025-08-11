//
//  CategoryModel.swift
//  Tracker
//
//  Created by oneche$$$ on 08.08.2025.
//

import Foundation

protocol CategoryModelDelegate: AnyObject {
    func categoryWasChosen(chosenCategory: String)
}

final class CategoryModel {
    weak var delegate: CategoryModelDelegate?
    var categories = [TrackerCategory]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("CategoriesChangedInModel"), object: nil)
        }
    }
    var chosenCategory = "" {
        didSet {
            delegate?.categoryWasChosen(chosenCategory: chosenCategory)
        }
    }
    
    private let store = TrackerCategoryStore()
    
    init() { getCategoriesFromCoreData() }
    
    func addCategoryToCoreData(category: String) {
        store.addCategoryToCoreData(category: TrackerCategory(name: category, trackers: []))
        getCategoriesFromCoreData()
    }
    
    func getCategoriesFromCoreData() {
        categories = store.getCategoriesFromCoreData()
    }
}
