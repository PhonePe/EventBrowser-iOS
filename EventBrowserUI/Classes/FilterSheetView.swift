//
//  FilterSheetView.swift
//  Pods
//
//  Created by Srikanth KV on 30/11/24.
//

import SwiftUI

@available(iOS 17.0, *)
public struct FilterSheetView: View {
    public var viewModel: EventBrowserContentView.ViewModel
    @State private var searchText: String = ""
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var selected = Set<String>()

    public var body: some View {
        NavigationView {
            VStack {
                Spacer()
                SearchBarView(searchText: $searchText).padding(.horizontal)
                List(filteredCategories, id: \.self) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        if selected.contains(category) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle()) // Allow tap on full row
                    .onTapGesture {
                        if selected.contains(category) {
                            selected.remove(category)
                        } else {
                            selected.insert(category)
                        }
                    }
                }
                .onAppear {
                    selected = viewModel.selectedCategories
                }
                .listStyle(.plain)
                .navigationBarTitle("Filter")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        dismiss()
                    },
                    trailing: HStack {
                        Button("Clear") {
                            selected.removeAll()
                        }
                        .foregroundColor(selected.count == 0 ? .gray : .red)
                        .disabled(selected.count == 0)
                        
                        Button("Apply") {
                            viewModel.selectedCategories = selected
                            dismiss()
                        }
                    }
                )
            }
        }
    }
    
    // Computed property to filter categories based on searchText
    private var filteredCategories: [String] {
        if searchText.isEmpty {
            return viewModel.categories
        } else {
            return viewModel.categories.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
