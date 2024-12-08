//
//  Item.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
public final class EventModel {
    public private(set) var eventName: String
    public private(set) var timestamp: Date
    
    @Relationship(deleteRule: .nullify)
    public var category: EventCategory
    
    public private(set) var eventDataJsonString: String?
    
    public init(eventName: String, timestamp: Date, category: String) {
        self.eventName = eventName
        self.timestamp = timestamp
        self.category = EventCategory(category: category)
    }
    
    @discardableResult
    public func setEventData(_ eventDataJsonString: String?) -> Self {
        self.eventDataJsonString = eventDataJsonString
        return self
    }
}
