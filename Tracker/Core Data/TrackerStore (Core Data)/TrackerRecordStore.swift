//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by oneche$$$ on 31.07.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore {
    private(set) var trackersRecordsLoadedFromCoreData: [TrackerRecord] = []
    private let context: NSManagedObjectContext
    private let calendar = Calendar.current
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("context couldn't be initialized") }
        context = appDelegate.persistentContainer.viewContext
        trackersRecordsLoadedFromCoreData = getTrackerRecordsFromCoreData()
    }
    
    func addTrackerRecordToCoreData(record: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = record.id
        trackerRecordCoreData.date = record.date
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
    
    func getTrackerRecordsFromCoreData() -> [TrackerRecord] {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerRecords = try? context.fetch(request) else { return [] }
        for trackerRecord in trackerRecords {
            trackersRecordsLoadedFromCoreData.append(TrackerRecord(id: trackerRecord.id ?? UUID(), date: trackerRecord.date ?? Date()))
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        appDelegate.saveContext()
        return trackersRecordsLoadedFromCoreData
    }
    
    func deleteTrackerRecordInCoreData(record: TrackerRecord) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackerRecords = try? context.fetch(request) else { return }
        for trackerRecord in trackerRecords {
            if trackerRecord.id == record.id && calendar.isDate(trackerRecord.date ?? Date(), inSameDayAs: record.date) {
                context.delete(trackerRecord)
            }
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
}
