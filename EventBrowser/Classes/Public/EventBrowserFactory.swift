//
//  EventBrowserFactory.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import Foundation
import SwiftData
import Combine

@available(iOS 17, *)
public final class EventBrowserFactory {
    
    public enum DataChange {
        case none
        case inserted([EventModel])
        case deleted([EventModel]?)
    }
    
    @Published var dataChange: DataChange = .none
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(name: String,
                dataClearanceTime: Date? = Calendar.current.date(byAdding: .hour, value: -24, to: .now)) {
        dataManager = SwiftDataManager()
        dataManager.initialise(name: name)
        
        eventManager = EventManager(modelContainer: dataManager.modelContainer)
        
        Task {
            await eventManager.valueChangedPublisher()
                .sink(receiveValue: { result in
                    self.dataChange = result
                })
                .store(in: &cancellables)
        }

        if let specificDate = dataClearanceTime {
            Task {
                await eventManager.deleteEventsWhichAreOlderThan(timestamp: specificDate)
            }
        }
    }
    
    public func query(searchText: String, selectedCategories: Set<EventCategory>) async -> Result<[EventModel], Error> {
        return await eventManager.query(searchText: searchText, selectedCategories: Set(selectedCategories.compactMap { $0.category }))
    }
    
    public func getAllCategories() async -> Result<[EventCategory], Error> {
        return await eventManager.getCategories()
    }
    
    @discardableResult
    public func insertEvent(event: EventModel) async -> Result<Bool, Error> {
        return await eventManager.insertEvent(event: event)
    }
    
    @discardableResult
    public func insertEvents(events: [EventModel]) async -> Result<Bool, Error> {
        return await eventManager.insertEvents(events: events)
    }
    
    @discardableResult
    public func deleteEvent(event: EventModel) async -> Result<Bool, Error> {
        return await eventManager.deleteEvent(event: event)
    }
    
    @discardableResult
    public func deleteEvents(events: [EventModel]) async -> Result<Bool, Error> {
        return await eventManager.deleteEvents(events: events)
    }
    
    @discardableResult
    public func deleteAllEvents() async -> Result<Bool, Error> {
        return await eventManager.deleteAllEvents()
    }
    
    public var modelContainer: ModelContainer {
        return dataManager.modelContainer
    }
    
    @objc
    func onModelSave(notification: Notification) {
        
    }
    
    let dataManager: SwiftDataManager
    let eventManager: EventManager
}
