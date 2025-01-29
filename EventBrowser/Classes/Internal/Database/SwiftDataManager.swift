//
//  SwiftDataManager.swift
//  EventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
class SwiftDataManager {
    private(set) var modelContainer: ModelContainer!
    private(set) var name: String?
    
    func initialise(name: String) {
        self.name = name
        
        modelContainer = {
            let schema = Schema([
                EventSDModel.self,
                EventSDCategory.self
            ])
            
            print(URL.documentsDirectory)

            let modelConfiguration = ModelConfiguration(name,
                                                        schema: schema,
                                                        url: URL.documentsDirectory.appending(path: name + "/" + name + ".sqlite"))
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
    }
}
