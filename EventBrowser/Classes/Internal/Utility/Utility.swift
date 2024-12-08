//
//  Utility.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import Foundation

func jsonStringToDictionary(_ jsonString: String) -> [String: Any]? {
    guard let data = jsonString.data(using: .utf8) else {
        print("Error: Unable to convert string to data.")
        return nil
    }
    
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        } else {
            print("Error: JSON is not in the expected format.")
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    
    return nil
}
