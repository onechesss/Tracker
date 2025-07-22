//
//  TrackerCategory.swift
//  Tracker
//
//  Created by oneche$$$ on 07.07.2025.
//

import Foundation

struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
    
    func addNewTracker(Tracker: Tracker) -> TrackerCategory {
        return TrackerCategory(name: self.name,
                               trackers: self.trackers + [Tracker])
    }
}
