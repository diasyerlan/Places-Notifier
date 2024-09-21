//
//  RoutesViewModel.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 21.08.2024.
//

import Foundation
import CoreLocation

class RoutesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var routes: [Route] = []
    @Published var currentLocation: CLLocation?
    @Published var isWithinRange: Bool = false
    private var locationManager = CLLocationManager()
    
    func updateRoute(_ route: Route) {
        if let index = routes.firstIndex(where: { $0.id == route.id }) {
            routes[index] = route
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            checkProximityToPlaces()
        }
    }
    
    func checkProximityToPlaces() {
        guard let userLocation = currentLocation else {
            return
        }
        for route in routes {
            if route.isActive {
                if let currentPlace = route.places.first(where: { !$0.isReached }) {
                    let placeLocation = CLLocation(latitude: currentPlace.coordinate.latitude, longitude: currentPlace.coordinate.longitude)
                    let distance = userLocation.distance(from: placeLocation)
                    print("DEBUG - \(distance) meters")
                    // If within 400 meters, mark the place as reached
                    if distance <= 400 {
                        isWithinRange = true
                        //                                triggerNotification(for: currentPlace)
                        
                        // Mark place as reached
                        if let index = route.places.firstIndex(where: { $0.id == currentPlace.id }) {
                            route.places[index].isReached = true
                            print("DEBUG - \(route.places[index].name) IS REACHED")
                        }
                    } else {

                        isWithinRange = false
                    }
                }
            }
        }
    }
}
