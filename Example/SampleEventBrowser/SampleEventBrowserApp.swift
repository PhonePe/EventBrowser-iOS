//
//  SampleEventBrowserApp.swift
//  SampleEventBrowser
//
//  Created by Srikanth KV on 10/11/24.
//

import SwiftUI
import SwiftData
import EventBrowser

@available(iOS 17, *)
@main
struct SampleEventBrowserApp: App {
    
    let eventBrowserFactory: EventBrowserFactory
    let dashEventBrowserFactory: EventBrowserFactory
    private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    init() {
        eventBrowserFactory = EventBrowserFactory(name: "FoxtrotEventBrowser")
        dashEventBrowserFactory = EventBrowserFactory(name: "DashEventBrowser")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                EventBrowserContentView(eventBrowserFactory: eventBrowserFactory)
                    .navigationBarTitle("Event Browser")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .onReceive(timer) { _ in
//                addTestEvent(instance: eventBrowserFactory)
//                addTestEvent(instance: dashEventBrowserFactory)
            }
        }
    }
    
    private func addTestEvent(instance: EventBrowserFactory) {
        Task {
            let eventModel = EventModel(eventName: randomString(length: 20), timestamp: Date(), category: "TEST_CATEGORY")
            eventModel
                .setEventData("""
{
    "ok": "OK",
    "next": "Next",
    "previous": "Previous",
    "title": "Welcome",
    "subtitle": "Glad to see you again",
    "device": ["iOS", "Android", "Web", "Desktop"]
}
""")
            
            let result = await instance.insertEvent(event: eventModel)
            
            switch result {
            case .failure(let error):
                print("Failed to add event: \(error)")
            case .success(_):
                print("Added Test event: \(eventModel.eventName)")
            }
        }
    }
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
