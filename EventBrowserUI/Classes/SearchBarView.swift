//
//  SearchBarView.swift
//  Pods
//
//  Created by Srikanth KV on 23/11/24.
//


import SwiftUI

public struct SearchBarView: View {
    @Binding var searchText: String
    
    public var body: some View {
        // Search bar
        HStack {
            Image(systemName: "magnifyingglass") // Search icon
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled(true) // Disable autocorrection
                .foregroundColor(.primary) // Match system text color
                .padding(8)
                .overlay(
                    // Clear button when there's text
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )
        }
        .background(Color(.systemGray6)) // Background color like native search bar
        .cornerRadius(10) // Rounded corners
    }
}
