//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by oneche$$$ on 16.08.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testTrackerViewControllerSnapshotForLightTheme() {
        let sut = TrackerViewController()
        assertSnapshot(of: sut, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackerViewControllerSnapshotForDarkTheme() {
        let sut = TrackerViewController()
        assertSnapshot(of: sut, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
}
