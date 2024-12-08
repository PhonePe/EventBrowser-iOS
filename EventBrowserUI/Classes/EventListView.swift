//
//  EventListView.swift
//  EventBrowser
//
//  Created by Srikanth KV on 11/11/24.
//

import Foundation
import SwiftUI
import SwiftData

@available(iOS 17, *)
public struct EventListView: View {
    private let events: [EventModel]
    private let onDeleteIndex: (IndexSet) -> Void?
    
    public init(events: [EventModel], onDeleteIndex: @escaping (IndexSet) -> Void) {
        self.events = events
        self.onDeleteIndex = onDeleteIndex
    }

    public var body: some View {
        List {
            ForEach(events) { event in
                NavigationLink {
                    if let eventDataJsonString = event.eventDataJsonString,
                       let dictionary = jsonStringToDictionary(eventDataJsonString) {
                        
                        Spacer()
                        Text(event.eventName)
                            .font(.headline)
                        Text(event.category.category)
                            .font(.subheadline)
                        Text(event.timestamp.formatted(Date.FormatStyle().day().month().hour().minute().second().secondFraction(.fractional(3))))
                            .font(.subheadline)
                        
                        Divider()
                        
                        List {
                            let jsonNode = parseJSON(dictionary)
                            JSONNodeView(jsonNode: jsonNode)
                        }.listStyle(.plain)
                    }
                    
                } label: {
                    VStack(alignment: .leading) {
                        Text(event.eventName)
                            .font(.headline)
                        Text(event.category.category)
                            .font(.subheadline)
                        Text(event.timestamp.formatted(Date.FormatStyle().day().month().hour().minute().second().secondFraction(.fractional(3))))
                            .font(.subheadline)
                    }
                }
            }
            .onDelete { indexSet in
                onDeleteIndex(indexSet)
            }
        }
        .listStyle(.plain)
        .overlay {
            if events.isEmpty {
                ContentUnavailableView.search
            }
        }
    }
}
