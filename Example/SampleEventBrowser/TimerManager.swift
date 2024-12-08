//
//  TimerManager.swift
//  SampleEventBrowser
//
//  Created by Srikanth KV on 07/12/24.
//

import Foundation

class TimerManager {
    private var timer: Timer?
    private var counter = 0

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.counter += 1
            print("Counter: \(self.counter)")
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
