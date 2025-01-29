//
//  ContentView.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
public struct EventBrowserContentView: View {    
    @State private var viewModel: ViewModel
    private let eventBrowserFactory: EventBrowserFactory
    
    @State private var showFilterSheet = false
    @State private var showDeleteAllConfirmation = false
    
    public init(eventBrowserFactory: EventBrowserFactory) {
        self.eventBrowserFactory = eventBrowserFactory
        self.viewModel = ViewModel(eventBrowserFactory: self.eventBrowserFactory)
    }
    
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                SearchBarView(searchText: $viewModel.searchText)
                Button(action: {
                    showFilterSheet.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(viewModel.selectedCategories.count > 0 ? .blue : .gray)
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal)
            
            EventListView(viewModel: viewModel, onDeleteIndex: { indexSet in
                viewModel.removeEvent(indexSet: indexSet)
            })
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showDeleteAllConfirmation = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
        }
        .modelContainer(eventBrowserFactory.modelContainer)
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(viewModel: viewModel)
        }
        .alert("Confirm Delete All", isPresented: $showDeleteAllConfirmation){
            Button("Cancel", role: .cancel) {}
            Button("Yes", role: .destructive) {
                viewModel.clearAllEvents()
            }
        } message: {
            Text("This will delete all events")
        }
    }
}

@available(iOS 17, *)
#Preview {
    EventBrowserContentView(eventBrowserFactory: EventBrowserFactory(name: "Test"))
        .modelContainer(for: EventSDModel.self, inMemory: true)
}
