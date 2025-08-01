//
//  Tracker.swift
//  Tracker
//
//  Created by oneche$$$ on 07.07.2025.
//

import UIKit

struct Tracker: Codable {
    let id: UUID
    let name: String
    let redPartOfColor: Float
    let greenPartOfColor: Float
    let bluePartOfColor: Float
    let emoji: String
    let schedule: String
}
