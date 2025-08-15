//
//  TrackerValueTransformer.swift
//  Tracker
//
//  Created by oneche$$$ on 30.07.2025.
//

import Foundation

final class TrackerValueTransformer: ValueTransformer {
    static func register() {
        ValueTransformer.setValueTransformer(
            TrackerValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: TrackerValueTransformer.self))
        )
    }
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let trackers = value as? [Tracker] else { return nil }
        return try? JSONEncoder().encode(trackers)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Tracker].self, from: data as Data)
    }
}
