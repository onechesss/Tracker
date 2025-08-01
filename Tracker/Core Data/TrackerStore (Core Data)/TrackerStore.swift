//
//  TrackerStore.swift
//  Tracker
//
//  Created by oneche$$$ on 31.07.2025.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    private(set) var trackersLoadedFromCoreData: [Tracker] = []
    private let context: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    
    override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("context couldn't be initialized") }
        context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        //fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        appDelegate.saveContext()
        getTrackersFromCoreData()
    }
    
    func getTrackersFromCoreData() {
        guard let loadedTrackers = fetchedResultsController.fetchedObjects else { return }
        for tracker in loadedTrackers {
            trackersLoadedFromCoreData.append(Tracker(id: tracker.id ?? UUID(),
                                                      name: tracker.name ?? "",
                                                      redPartOfColor: tracker.redPartOfColor,
                                                      greenPartOfColor: tracker.greenPartOfColor,
                                                      bluePartOfColor: tracker.bluePartOfColor,
                                                      emoji: tracker.emoji ?? "",
                                                      schedule: tracker.schedule ?? ""))
        }
    }
    
    func addTrackerToCoreData(tracker: Tracker, in category: TrackerCategory, with trackers: [Tracker]) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.redPartOfColor = tracker.redPartOfColor
        trackerCoreData.greenPartOfColor = tracker.greenPartOfColor
        trackerCoreData.bluePartOfColor = tracker.bluePartOfColor
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCoreData.category = trackerCategoryCoreData
        trackerCategoryCoreData.name = category.name
        trackerCategoryCoreData.tracker = trackerCoreData
        trackerCategoryCoreData.trackers = trackers as NSObject
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
}
