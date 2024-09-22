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
    
    init(name: String, places: [Place] = [], isActive: Bool) {
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
    
    // MARK: - Codable Conformance
        enum CodingKeys: String, CodingKey {
            case id, name, places, isActive
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            places = try container.decode([Place].self, forKey: .places)
            isActive = try container.decode(Bool.self, forKey: .isActive)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(places, forKey: .places)
            try container.encode(isActive, forKey: .isActive)
        }
}
