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
    public let viewModel: EventBrowserContentView.ViewModel
    private let onDeleteIndex: (IndexSet) -> Void?
    
    public init(viewModel: EventBrowserContentView.ViewModel, onDeleteIndex: @escaping (IndexSet) -> Void) {
        self.viewModel = viewModel
        self.onDeleteIndex = onDeleteIndex
    }

    public var body: some View {
        List {
            ForEach(viewModel.events) { event in
                NavigationLink {
                    if let eventDataJsonString = event.eventDataJsonString,
                       let dictionary = jsonStringToDictionary(eventDataJsonString) {
                        
                        Spacer()
                        Text(event.eventName)
                            .font(.headline)
                        Text(event.category)
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
                        Text(event.category)
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
            if viewModel.events.isEmpty {
                ContentUnavailableView.search
            }
        }
    }
}
