//
//  Analytics manager.swift
//  Tracker
//
//  Created by oneche$$$ on 17.08.2025.
//

import AppMetricaCore

enum AnalyticsParametersEvent {
    static let click = "click"
    static let open = "open"
    static let close = "close"
}

enum AnalyticsParametersScreen {
    static let main = "Main"
}

enum AnalyticsParametersItem {
    static let addTrackerButtonTapped = "add_track"
    static let trackerDoneOrNotDoneButtonTapped = "track"
    static let filterButtonTapped = "filter"
    static let editButtonInContextualMenuTapped = "edit"
    static let deleteButtonInContextualMenuTapped = "delete"
}



final class AnalyticsManager {
    static func reportEvent(eventName: String, onScreen: String, triggeredItem: String?) {
        var parameters: [String: String] = [:]
        if let triggeredItem {
            parameters = ["event": eventName, "screen": onScreen, "item": triggeredItem]
        } else {
            parameters = ["event": eventName, "screen": onScreen]
        }
        AppMetrica.reportEvent(name: eventName, parameters: parameters)
    }
}
