//
//  RoutesViewModel.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 21.08.2024.
//

import Foundation
import CoreLocation
import UserNotifications

class RoutesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
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
        locationManager.allowsBackgroundLocationUpdates = true
        requestNotificationAuthorization()
        
        // Set notification center delegate
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("DEBUG - Error requesting notification permission: \(error.localizedDescription)")
            }
        }
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
                        
                        // Mark place as reached
                        if let index = route.places.firstIndex(where: { $0.id == currentPlace.id }) {
                            route.places[index].isReached = true
                            print("DEBUG - \(route.places[index].name) IS REACHED")
                            
                            // Send notification
                            sendNotification(for: currentPlace)
                        }
                    } else {
                        isWithinRange = false
                    }
                }
            }
        }
    }
    
    func sendNotification(for place: Place) {
        let content = UNMutableNotificationContent()
        content.title = "You're close to \(place.name)!"
        content.body = "You are within 400 meters of \(place.name)."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("DEBUG - Error adding notification request: \(error.localizedDescription)")
            }
        }
    }
    
    // UNUserNotificationCenterDelegate method to handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display notification even if app is in the foreground
        completionHandler([.banner, .sound])
    }
}
