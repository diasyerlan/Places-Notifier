//
//  Route.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 20.08.2024.
//

import Foundation
import Combine

class Route: ObservableObject, Identifiable, Equatable, Hashable, Codable {
    var id = UUID()
    @Published var name: String
    @Published var places: [Place] {
        didSet {
            for place in places {
                if !place.isReached {
                    return
                }
            }
            isActive = false
        }
    }
    @Published var isActive: Bool
    var activationPeriodType: RouteActivationPeriod
    private var dailyTimer: Timer?

    
    init(name: String, places: [Place] = [], isActive: Bool, activationPeriodType: RouteActivationPeriod) {
        self.name = name
        self.places = places
        self.isActive = isActive
        self.activationPeriodType = activationPeriodType
        
        scheduleDailyUpdate()
    }
    
    func scheduleDailyUpdate() {
            // Invalidate any existing timer
            dailyTimer?.invalidate()
            
            // Calculate the time interval until the next midnight
            let now = Date()
            let nextMidnight = Calendar.current.nextDate(after: now, matching: DateComponents(hour: 0), matchingPolicy: .nextTime)!
            let timeIntervalUntilMidnight = nextMidnight.timeIntervalSince(now)
            
            // Create a timer that fires at midnight, then repeats every 24 hours
            dailyTimer = Timer.scheduledTimer(withTimeInterval: timeIntervalUntilMidnight, repeats: false) { [weak self] _ in
                self?.updateActivationStatus()
                self?.scheduleRepeatingMidnightTimer() // Start the repeating 24-hour timer
            }
        }
        
        /// Schedule a repeating timer that triggers every 24 hours at midnight
        private func scheduleRepeatingMidnightTimer() {
            dailyTimer = Timer.scheduledTimer(withTimeInterval: 24 * 60 * 60, repeats: true) { [weak self] _ in
                self?.updateActivationStatus()
            }
        }
    func updateActivationStatus() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        
        switch activationPeriodType {
        case .weekdays:
            isActive = (weekday >= 2 && weekday <= 6) // 1 = Sunday, 7 = Saturday
        case .weekends:
            isActive = (weekday == 1 || weekday == 7)
        case .singleDay:
           return
        case .everyDay:
            isActive = true
        }
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Codable Conformance
    enum CodingKeys: String, CodingKey {
        case id, name, places, isActive, activationPeriodType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        places = try container.decode([Place].self, forKey: .places)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        activationPeriodType = try container.decode(RouteActivationPeriod.self, forKey: .activationPeriodType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(places, forKey: .places)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(activationPeriodType, forKey: .activationPeriodType)
        
    }
}
