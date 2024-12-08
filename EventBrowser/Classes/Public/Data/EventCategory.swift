//
//  EventModel 2.swift
//  Pods
//
//  Created by Srikanth KV on 07/12/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
public final class EventCategory {
    @Relationship(deleteRule: .cascade, inverse: \EventModel.category)
    public var events: [EventModel]?

    @Attribute(.unique)
    public var category: String
    
    public init(category: String) {
        self.category = category
    }
}
