//
//  Route.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 20.08.2024.
//

import Foundation
import Combine

class Route: ObservableObject, Identifiable, Equatable, Hashable {
    var id = UUID()
    @Published var name: String
    @Published var places: [String]
    @Published var isActive: Bool
    
    init(name: String, places: [String] = [], isActive: Bool) {
        self.name = name
        self.places = places
        self.isActive = isActive
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
