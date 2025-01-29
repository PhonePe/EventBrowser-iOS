//
//  ContentViewModel.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

@available(iOS 17, *)
extension EventBrowserContentView {
    
    @Observable
    public class ViewModel {
        public var searchText: String = "" {
            didSet {
                fetchEvents()
            }
        }
        
        public private(set) var events: [EventModel] = []
        public private(set) var categories: [EventCategory] = []
        
        private static let userDefaultsKey: String = "com.eventbrowser.selectedCategories"
        public var selectedCategories: Set<EventCategory> = Set<EventCategory>() {
            didSet {
                UserDefaults.standard.set(selectedCategories.compactMap {$0.category}, forKey: Self.userDefaultsKey)
                
                fetchEvents()
            }
        }
        
        public init(eventBrowserFactory: EventBrowserFactory) {
            self.eventBrowserFactory = eventBrowserFactory
            self.eventBrowserFactory.$dataChange.sink(receiveValue: { [weak self] result in
                self?.fetch()
            })
            .store(in: &cancellables)
            
            if let selCategories = UserDefaults.standard.stringArray(forKey: Self.userDefaultsKey) {
                selectedCategories = Set(selCategories.compactMap {EventCategory(category: $0)})
            }
        }
        
        func removeEvent(indexSet: IndexSet) {
            Task {
                if let index = indexSet.first {
                    let event = events[index]
                    let result = await self.eventBrowserFactory.deleteEvent(event: event)
                    
                    switch result {
                    case .failure(let error):
                        print("Failed to delete event: \(error)")
                    case .success(_):
                        break
                    }
                }
            }
        }
        
        func clearAllEvents() {
            Task {
                let result = await self.eventBrowserFactory.deleteAllEvents()
                
                switch result {
                case .failure(let error):
                    print("Failed to delete events: \(error)")
                case .success(_):
                    break
                }
            }
        }
        
        private func fetch() {
            fetchEvents()
            updateCategories()
        }
        
        private func fetchEvents() {
            Task {
                let result = await eventBrowserFactory.query(searchText: searchText, selectedCategories: selectedCategories)
                switch result {
                case .failure(let error):
                    print("Failed to fetch event: \(error)")
                case .success(let events):
                    DispatchQueue.main.async {
                        self.events = events
                    }
                    break
                }
            }
        }
        
        private func updateCategories() {
            Task {
                let result = await eventBrowserFactory.getAllCategories()
                switch result {
                case .failure(let error):
                    print("Failed to fetch event: \(error)")
                case .success(let categories):
                    DispatchQueue.main.async {
                        self.categories = categories
                    }
                    break
                }
            }
        }
        
        public let eventBrowserFactory: EventBrowserFactory
        private var cancellables = Set<AnyCancellable>()
    }
}
