//
//  JSONViewerViewModel.swift
//  EventBrowser
//
//  Created by Srikanth KV on 13/11/24.
//

import Foundation

@available(iOS 17.0, *)

extension JSONNodeView {
    @Observable
    class ViewModel {
        let rootNode: JSONNode
        private(set) var expandedNodes: Set<UUID>
        
        init(rootNode: JSONNode) {
            self.rootNode = rootNode
            self.expandedNodes = []
            addIDsByDefault(for: rootNode)
        }
        
        func isExpanded(_ id: UUID) -> Bool {
            expandedNodes.contains(id)
        }
        
        func toggleExpandCollapse(_ id: UUID) {
            if expandedNodes.contains(id) {
                expandedNodes.remove(id)
            } else {
                expandedNodes.insert(id)
            }
        }
        
        private func addIDsByDefault(for node: JSONNode) {
            //        expandedNodes.insert(node.id)
            
            switch node {
            case .dictionary(let dict, _):
                for (_, value) in dict {
                    expandedNodes.insert(value.id)
                }
            case .array(let array, _):
                for item in array {
                    expandedNodes.insert(item.id)
                }
            case .value:
                break
            }
        }
    }
}
