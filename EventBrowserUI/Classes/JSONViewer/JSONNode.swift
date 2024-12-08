//
//  JSONNode.swift
//  EventBrowser
//
//  Created by Srikanth KV on 13/11/24.
//

import Foundation
import SwiftUI

enum JSONNode: Identifiable {
    case dictionary([String: JSONNode], id: UUID = UUID())
    case array([JSONNode], id: UUID = UUID())
    case value(String, id: UUID = UUID())
    
    var id: UUID {
        switch self {
        case .dictionary(_, let id), .array(_, let id), .value(_, let id):
            return id
        }
    }
}

func parseJSON(_ json: Any) -> JSONNode {
    if let dict = json as? [String: Any] {
        return .dictionary(dict.mapValues { parseJSON($0) })
    } else if let array = json as? [Any] {
        return .array(array.map { parseJSON($0) })
    } else {
        return .value(String(describing: json))
    }
}
