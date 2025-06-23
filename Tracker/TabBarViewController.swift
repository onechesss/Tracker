//
//  TabBar.swift
//  Tracker
//
//  Created by oneche$$$ on 21.06.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
print("asfsa")
        super.viewDidLoad()
        let trackerViewController = TrackerViewController()
        let statisticsViewController = StatisticsViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackers (tabBarItem)"), selectedImage: nil)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statistics (tabBarItem)"), selectedImage: nil)
        viewControllers = [trackerViewController, statisticsViewController]
    }
}
