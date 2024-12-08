//
//  JSONViewerView.swift
//  EventBrowser
//
//  Created by Srikanth KV on 13/11/24.
//

import Foundation
import SwiftUI

@available(iOS 17, *)
struct JSONNodeView: View {
    @State private var viewModel: ViewModel
    
    init(jsonNode: JSONNode) {
        self.viewModel = ViewModel(rootNode: jsonNode)
    }
    
    var body: some View {
        switch viewModel.rootNode {
        case .dictionary(let dict, _):
            VStack(alignment: .leading) {
                ForEach(Array(dict.keys), id: \.self) { key in
                    if let value = dict[key] {
                        HStack {
                            Image(systemName: viewModel.isExpanded(value.id) ? "chevron.down" : "chevron.right")
                            Text(key).bold().foregroundStyle(.blue)
                            Spacer()
                        }
                        .onTapGesture {
                            viewModel.toggleExpandCollapse(value.id)
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        
                        if viewModel.isExpanded(value.id) {
                            JSONNodeView(jsonNode: value)
                                .padding(.leading, 20)
                        }
                    }
                }
            }
            
        case .array(let array, _):
            VStack(alignment: .leading) {
                ForEach(Array(array.enumerated()), id: \.element.id) { index, item in
                    HStack {
                        Image(systemName: viewModel.isExpanded(item.id) ? "chevron.down" : "chevron.right")
                        Text("[\(index)]").bold().foregroundStyle(.orange) // Display index
                    }
                    .onTapGesture {
                        viewModel.toggleExpandCollapse(item.id)
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    
                    if viewModel.isExpanded(item.id) {
                        JSONNodeView(jsonNode: item)
                            .padding(.leading, 20)
                    }
                }
            }
            
        case .value(let stringValue, _):
            Text(stringValue.isEmpty ? "Empty" : stringValue)
                .foregroundStyle(stringValue.isEmpty ? .tertiary : .primary)
                .padding(.leading, 8)
        }
    }
}
