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
    @Published var places: [Place]
    @Published var isActive: Bool
    var activationPeriodType: RouteActivationPeriod
    private var dailyTimer: DispatchSourceTimer?
    
    
    
    init(name: String, places: [Place] = [], isActive: Bool, activationPeriodType: RouteActivationPeriod) {
        self.name = name
        self.places = places
        self.isActive = isActive
        self.activationPeriodType = activationPeriodType
        
        setupDailyTimer()
    }
    
    deinit {
        // Cancel the timer when the object is deallocated
        dailyTimer?.cancel()
        dailyTimer = nil
    }
    
    func setupDailyTimer() {
        // Create a DispatchSourceTimer that triggers at midnight (or daily)
        let queue = DispatchQueue.global(qos: .background)
        dailyTimer = DispatchSource.makeTimerSource(queue: queue)
        
        // Configure the timer to fire at midnight every day
        let now = Date()
        let calendar = Calendar.current
        
        // Calculate the next midnight time
        if let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 13, minute: 04, second: 0), matchingPolicy: .nextTime) {
            let timeInterval = nextMidnight.timeIntervalSince(now)
            dailyTimer?.schedule(deadline: .now() + timeInterval, repeating: 24 * 60 * 60) // Repeat every 24 hours
            
            // Set the event handler for when the timer fires
            dailyTimer?.setEventHandler { [weak self] in
                DispatchQueue.main.async {
                    self?.updateActivationStatus()
                    for index in self!.places.indices {
                        self!.places[index].isReached = false
                    }
                }
            }
            
            // Start the timer
            dailyTimer?.resume()
        }
    }
    
    func updateActivationStatus() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        
        switch activationPeriodType {
        case .weekdays:
            isActive = (weekday >= 2 && weekday <= 6) ? true : false
        case .weekends:
            isActive = (weekday == 1 || weekday == 7) ? true : false
        case .singleDay:
            for place in places {
                if !place.isReached {
                    isActive = true
                    return
                }
            }
            isActive = false
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
        
        setupDailyTimer()

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
