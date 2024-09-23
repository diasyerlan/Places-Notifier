//
//  PlacesViewModel.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 23.09.2024.
//

import Foundation

class PlacesViewModel: ObservableObject {
    var route: Route
    
    init(route: Route) {
        self.route = route
    }
    
    func delete(place: Place) {
        if let index = route.places.firstIndex(where: { $0.id == place.id }) {
            route.places.remove(at: index)
        }
    }
    
    func rename(place: Place, placeName: String) {
        if let index = route.places.firstIndex(of: place) {
            route.places[index].name = placeName
        }
    }
}
