//
//  Item.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
public class EventModel: Identifiable {
    public private(set) var eventName: String
    public private(set) var timestamp: Date
    public private(set) var category: String
    
    public private(set) var eventDataJsonString: String?
    
    public let id: UUID
    
    public init(id: UUID = UUID(), eventName: String, timestamp: Date, category: String) {
        self.id = id
        self.eventName = eventName
        self.timestamp = timestamp
        self.category = category
    }
    
    @discardableResult
    public func setEventData(_ eventDataJsonString: String?) -> Self {
        self.eventDataJsonString = eventDataJsonString
        return self
    }
}


@available(iOS 17, *)
@Model
final class EventSDModel {
    private(set) var id: UUID
    private(set) var eventName: String
    private(set) var timestamp: Date
    
    @Relationship(deleteRule: .nullify)
    private(set) var category: EventSDCategory
    
    private(set) var eventDataJsonString: String?
    
    init(id: UUID, eventName: String, timestamp: Date, category: EventSDCategory) {
        self.id = id
        self.eventName = eventName
        self.timestamp = timestamp
        self.category = category
    }
    
    @discardableResult
    func setEventData(_ eventDataJsonString: String?) -> Self {
        self.eventDataJsonString = eventDataJsonString
        return self
    }
}
