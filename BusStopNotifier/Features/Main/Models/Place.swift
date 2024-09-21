//
//  Place.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 21.09.2024.
//

import Foundation
import CoreLocation

struct Place: Hashable, Equatable {
    
    let id = UUID()
    let name: String
    var isReached: Bool
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
