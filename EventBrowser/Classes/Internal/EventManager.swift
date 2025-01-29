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
            let descriptor = FetchDescriptor<EventSDModel>(
                predicate: #Predicate<EventSDModel> { event in
                    (searchText.isEmpty || event.eventName.localizedStandardContains(searchText)) &&
                    (selectedCategories.isEmpty || selectedCategories.contains(event.category.category))
                },
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )
            
            let eventSDModels = try modelContext.fetch(descriptor)
            
            let eventModels = eventSDModels.compactMap { eventSDModel in
                let model = EventModel(id: eventSDModel.id,
                                       eventName: eventSDModel.eventName,
                                       timestamp: eventSDModel.timestamp,
                                       category: eventSDModel.category.category)
                    .setEventData(eventSDModel.eventDataJsonString)
                return model
            }
            return .success(eventModels)
        } catch {
            return .failure(error)
        }
    }
    
    func getCategories() -> Result<[EventCategory], Error> {
        do {
            let descriptor = FetchDescriptor<EventSDCategory>(
                sortBy: [SortDescriptor(\.category, order: .forward)]
            )
            let eventModels = try modelContext.fetch(descriptor)
            let categories = eventModels.compactMap { EventCategory(category: $0.category) }
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
            let category = event.category
            let fetchDescriptor = FetchDescriptor<EventSDCategory>(
                predicate: #Predicate { $0.category == category }
            )
            
            // Perform the fetch
            let categoryToUse: EventSDCategory
            if let existingCategory = try? context.fetch(fetchDescriptor).first {
                categoryToUse = existingCategory
            } else {
                categoryToUse = EventSDCategory(category: event.category)
            }
            
            let eventSDModel = EventSDModel(id: event.id,
                                            eventName: event.eventName,
                                            timestamp: event.timestamp,
                                            category: categoryToUse)
                .setEventData(event.eventDataJsonString)
            context.insert(eventSDModel)
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
        
        do {
            for event in events {
                let eventName = event.eventName
                let timestamp = event.timestamp
                let category = event.category
                
                try context.delete(model: EventSDModel.self, where: #Predicate {
                    $0.eventName == eventName &&
                    $0.timestamp == timestamp &&
                    $0.category.category == category
                })
            }
            
            try context.save()
            update(dataChange: .deleted(events))
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteAllEvents() -> Result<Bool, Error> {
        do {
            try modelContext.delete(model: EventSDCategory.self)
            update(dataChange: .deleted(nil))
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteEventsWhichAreOlderThan(timestamp: Date) -> Result<Bool, Error> {
        do {
            try modelContext.delete(model: EventSDModel.self, where: #Predicate<EventSDModel> { event in
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
