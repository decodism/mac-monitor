//
//  ThrottleManager.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 6/23/23.
//

import Foundation


class ThrottleManager {
    private var eventRateCounter: Int = 0
    private var eventTimestamp: Date = Date()
    
    private let heavyFlowRate: Double = 300
    private let throttleFactor: Double = 0.001
    private let minSaveInterval: Double = 0.1
    private let maxSaveInterval: Double = 4.5
    private let deThrottleRate: Double = 0.1
    
    private var _saveInterval: Double = 0.1

    var eventRate: Double {
        let elapsedTime = Date().timeIntervalSince(eventTimestamp)
        return Double(eventRateCounter) / elapsedTime
    }
    
    var saveInterval: Double {
        return _saveInterval
    }
    
    func registerEvent() {
        eventRateCounter += 1
        let elapsedTime = Date().timeIntervalSince(eventTimestamp)
        
        if elapsedTime >= 1.0 {
            adjustSaveInterval(eventRate: Double(eventRateCounter) / elapsedTime)
            eventRateCounter = 0
            eventTimestamp = Date()
        }
    }
    
    private func adjustSaveInterval(eventRate: Double) {
        if eventRate >= heavyFlowRate {
            let dynamicThrottleRate = throttleFactor * (eventRate - heavyFlowRate)
            _saveInterval = min(_saveInterval + dynamicThrottleRate, maxSaveInterval)
        } else if _saveInterval > minSaveInterval {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let self = self else { return }
                self._saveInterval = max(self._saveInterval - self.deThrottleRate, self.minSaveInterval)
            }
        }
    }
}
