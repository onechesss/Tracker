//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by oneche$$$ on 31.07.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    private(set) var categoriesFromCoreData: [TrackerCategory] = []
    private let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("context couldn't be initialized") }
        return appDelegate.persistentContainer.viewContext
    }()
    
    func addCategoryToCoreData(category: TrackerCategory) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = category.name
        trackerCategoryCoreData.trackers = category.trackers as NSObject
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
    
    func getCategoriesFromCoreData() -> [TrackerCategory] {
        categoriesFromCoreData = []
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        guard let categories = try? context.fetch(request) else { return [] }
        for category in categories {
            categoriesFromCoreData.append(TrackerCategory(name: category.name ?? "", trackers: category.trackers as? [Tracker] ?? []))
        }
        return categoriesFromCoreData
    }
    
    func addTrackerToCategoryCoreData(category: TrackerCategory, tracker: Tracker) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        guard let categories = try? context.fetch(request) else { return }
        let categoryWithNewTracker = category.addNewTracker(Tracker: tracker)
        for category in categories {
            if category.name == categoryWithNewTracker.name {
                category.trackers = categoryWithNewTracker.trackers as NSObject
            }
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }

    func deleteTrackerFromCategoryCoreData(tracker: Tracker) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        guard let categories = try? context.fetch(request) else { return }
        for category in categories {
            guard var trackersArray = category.trackers as? [Tracker] else { return }
            for _ in trackersArray {
                trackersArray.removeAll(where: { $0.id == tracker.id } )
                category.trackers = trackersArray as NSObject
            }
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
}
