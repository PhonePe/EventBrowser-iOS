//
//  EventModel 2.swift
//  Pods
//
//  Created by Srikanth KV on 07/12/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
public final class EventCategory: Hashable {
    public static func == (lhs: EventCategory, rhs: EventCategory) -> Bool {
        return lhs.category == rhs.category
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(category)
    }
    
    public let category: String
    
    public init(category: String) {
        self.category = category
    }
}

@available(iOS 17, *)
@Model
final class EventSDCategory {
    @Relationship(deleteRule: .cascade, inverse: \EventSDModel.category)
    var events: [EventSDModel]?

    @Attribute(.unique)
    private(set) var category: String
    
    init(category: String) {
        self.category = category
    }
}
