//
//  EventManager.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import Foundation
import SwiftData
import Combine

@available(iOS 17, *)

@ModelActor
actor EventManager {
    func valueChangedPublisher() -> PassthroughSubject<EventBrowserFactory.DataChange, Never> {
        return valueChangedSubject
    }
    
    func query(searchText: String, selectedCategories: Set<String>) -> Result<[EventModel], Error> {
        do {
            let descriptor = FetchDescriptor<EventModel>(
                predicate: #Predicate<EventModel> { event in
                    (searchText.isEmpty || event.eventName.localizedStandardContains(searchText)) &&
                    (selectedCategories.isEmpty || selectedCategories.contains(event.category.category))
                },
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            
            let eventModels = try modelContext.fetch(descriptor)
            return .success(eventModels)
        } catch {
            return .failure(error)
        }
    }
    
    func getCategories() -> Result<[String], Error> {
        do {
            let descriptor = FetchDescriptor<EventCategory>(
                sortBy: [SortDescriptor(\.category, order: .forward)]
            )
            let eventModels = try modelContext.fetch(descriptor)
            let categories = eventModels.compactMap { $0.category }
            return .success(categories)
        } catch {
            return .failure(error)
        }
    }
    
    func insertEvent(event: EventModel) -> Result<Bool, Error> {
        return insertEvents(events: [event])
    }
    
    func insertEvents(events: [EventModel]) -> Result<Bool, Error> {
        let context = modelContext
        for event in events {
            context.insert(event)
        }
        
        do {
            try context.save()
            update(dataChange: .inserted(events))
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteEvent(event: EventModel) -> Result<Bool, Error> {
        return deleteEvents(events: [event])
    }
    
    func deleteEvents(events: [EventModel]) -> Result<Bool, Error> {
        let context = modelContext
        for event in events {
            context.delete(event)
        }
        
        do {
            try context.save()
            update(dataChange: .deleted(events))
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteAllEvents() -> Result<Bool, Error> {
        do {
            try modelContext.delete(model: EventCategory.self)
            update(dataChange: .deleted(nil))
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteEventsWhichAreOlderThan(timestamp: Date) -> Result<Bool, Error> {
        do {
            try modelContext.delete(model: EventModel.self, where: #Predicate<EventModel> { event in
                event.timestamp <= timestamp
            })
            try modelContext.save()
            update(dataChange: .deleted(nil))
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    private var dataChange: EventBrowserFactory.DataChange = .none
    private var valueChangedSubject = PassthroughSubject<EventBrowserFactory.DataChange, Never>()
    
    private func update(dataChange: EventBrowserFactory.DataChange) {
        self.dataChange = dataChange
        valueChangedSubject.send(self.dataChange)
    }
}
