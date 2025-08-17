//
//  StatisticModel.swift
//  Tracker
//
//  Created by oneche$$$ on 17.08.2025.
//

import Foundation

final class StatisticsModel {
    private weak var view: StatisticsViewController?
    private var trackerRecordStore = TrackerRecordStore()
    private var trackerCategoryStore = TrackerCategoryStore()
    private let calendar = Calendar.current
    
    private var idealDaysValue: Int {
        get {
            UserDefaults.standard.integer(forKey: "idealDaysValue")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "idealDaysValue")
        }
    }

    func getBestPeriod() -> String {
        let trackerRecords = trackerRecordStore.getTrackerRecordsFromCoreData()
        var maxStreak = 0
        let groupedRecords = Dictionary(grouping: trackerRecords) { $0.id }
        for (_, records) in groupedRecords {
            let sortedRecords = records.sorted { $0.date < $1.date }
            var currentStreak = 1
            for i in 0..<sortedRecords.count - 1 {
                let currentDate = sortedRecords[i].date
                let nextDate = sortedRecords[i+1].date
                if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate),
                   calendar.isDate(nextDate, inSameDayAs: nextDay) {
                    currentStreak += 1
                } else {
                    maxStreak = max(maxStreak, currentStreak)
                    currentStreak = 1
                }
            }
            maxStreak = max(maxStreak, currentStreak)
        }
        return String(maxStreak)
    }
    
    func getIdealDays() -> String {
        let records = trackerRecordStore.getTrackerRecordsFromCoreData()
        let categories = trackerCategoryStore.getCategoriesFromCoreData()
        var currentTrackerIDs = Set<UUID>()
        for category in categories {
            for tracker in category.trackers {
                currentTrackerIDs.insert(tracker.id)
            }
        }
        var recordsByDate = [Date: [TrackerRecord]]()
        for record in records {
            let dateKey = calendar.startOfDay(for: record.date)
            recordsByDate[dateKey, default: []].append(record)
        }
        if !currentTrackerIDs.isEmpty {
            var currentPerfectDays = 0
            for (_, recordsInDay) in recordsByDate {
                let completedIDs = Set(recordsInDay.map { $0.id })
                if completedIDs == currentTrackerIDs {
                    currentPerfectDays += 1
                }
            }
            if currentPerfectDays > idealDaysValue {
                idealDaysValue = currentPerfectDays
            }
        }
        return String(idealDaysValue)
    }
    
    func getHowManyTrackersDoneEver() -> String {
        String(trackerRecordStore.getTrackerRecordsFromCoreData().count)
    }
    
    func getMeanValueOfDoneTrackers() -> String {
        let trackerRecords = trackerRecordStore.getTrackerRecordsFromCoreData()
        let groupedRecords = Dictionary(grouping: trackerRecords) { record in
            calendar.startOfDay(for: record.date)
        }
        let countsPerDay = groupedRecords.values.map { $0.count }
        guard !countsPerDay.isEmpty else { return "0" }
        let average = Float(countsPerDay.reduce(0, +)) / Float(countsPerDay.count)
        return String(average)
    }
}

