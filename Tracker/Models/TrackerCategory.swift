//
//  TrackerCategory.swift
//  Tracker
//
//  Created by oneche$$$ on 07.07.2025.
//

import Foundation

struct TrackerCategory {
    let name: String
    var trackers: [Tracker] // нельзя сделать let т.к. иначе нельзя будет создать новый трекер в существующей категории
}
