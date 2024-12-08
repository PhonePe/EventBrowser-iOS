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
        public private(set) var categories: [String] = []
        
        public var selectedCategories: Set<String> = Set<String>() {
            didSet {
                fetchEvents()
            }
        }
        
        public init(eventBrowserFactory: EventBrowserFactory) {
            self.eventBrowserFactory = eventBrowserFactory
            self.eventBrowserFactory.$dataChange.sink(receiveValue: { [weak self] result in
                self?.fetch()
            })
            .store(in: &cancellables)
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
                    self.events = events
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
                    self.categories = categories
                    break
                }
            }
        }
        
        public let eventBrowserFactory: EventBrowserFactory
        private var cancellables = Set<AnyCancellable>()
    }
}
