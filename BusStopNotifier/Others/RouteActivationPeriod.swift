//
//  RouteActivationPeriod.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 25.09.2024.
//

import Foundation

enum RouteActivationPeriod: String, CaseIterable, Identifiable, Codable {
    case weekdays = "Weekdays"
    case weekends = "Weekends"
    case singleDay = "Single Day"
    case everyDay = "Every Day"
    
    var id: String { rawValue }
}
