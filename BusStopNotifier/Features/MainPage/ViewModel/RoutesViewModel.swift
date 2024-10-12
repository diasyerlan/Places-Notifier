//
//  RoutesViewModel.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 21.08.2024.
//

import Foundation
import CoreLocation
import UserNotifications
import Alamofire

class RoutesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    @Published var isWithinRange: Bool = false
    private var locationManager = CLLocationManager()
    @Published var routes: [Route] = []
    
    private let notifyByCallKey = "notifyByCall"
    private let distanceKey = "distance"
    @Published var notifyByCall: Bool {
        didSet {
            UserDefaults.standard.set(notifyByCall, forKey: notifyByCallKey)
        }
    }
    
    @Published var distance: Int {
        didSet {
            UserDefaults.standard.set(distance, forKey: distanceKey)
        }
    }
    
    
    override init() {
        
        let storedNotifyByCall = UserDefaults.standard.bool(forKey: notifyByCallKey)
        let storedDistance = UserDefaults.standard.integer(forKey: distanceKey)
        
        self.notifyByCall = storedNotifyByCall
        self.distance = storedDistance != 0 ? storedDistance : 400
        
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        NotificationService.shared.requestNotificationAuthorization()
        
        loadRoutes()
        
    }
    
    // MARK: - Updating the current user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            checkProximityToPlaces()
        }
    }
    // MARK: - Checking if the destination is close enough
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
                    
                    if distance <= Double(self.distance) {
                        isWithinRange = true
                        
                        if let index = route.places.firstIndex(where: { $0.id == currentPlace.id }) {
                            route.places[index].isReached = true
                            print("DEBUG - \(route.places[index].name) IS REACHED")
                            saveRoutes()
                            if notifyByCall {
                                CallService.shared.reportIncomingCall(uuid: UUID(), handle: "You arrived!")
                            } else {
                                NotificationService.shared.sendNotification(for: currentPlace)
                            }
                        }
                    } else {
                        isWithinRange = false
                    }
                }
            }
        }
    }
    
    
    // MARK: - Updates the state of the route when back button is tapped
    func updateRoute(_ route: Route) {
        if let index = routes.firstIndex(where: { $0.id == route.id }) {
            routes[index] = route
        }
        saveRoutes()
    }
    
    // MARK: - functions to store and load the data from User Defaults
    func saveRoutes() {
        do {
            let data = try JSONEncoder().encode(routes)
            UserDefaults.standard.set(data, forKey: "savedRoutes")
            print("DEBUG - Routes saved to UserDefaults")
            
        } catch {
            print("DEBUG - Failed to save routes: \(error.localizedDescription)")
        }
    }
    
    func loadRoutes() {
        if let data = UserDefaults.standard.data(forKey: "savedRoutes") {
            do {
                routes = try JSONDecoder().decode([Route].self, from: data)
                print("DEBUG - Routes loaded from UserDefaults")
            } catch {
                print("DEBUG - Failed to load routes: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(route: Route) {
        if let index = routes.firstIndex(where: { $0.id == route.id }) {
            routes.remove(at: index)
        }
        saveRoutes()
    }
    
    func renameRoute(route: Route, routeName: String) {
        if let index = routes.firstIndex(of: route) {
            routes[index].name = routeName
            print("DEBUG - \(routes[index].name)")
        }
        saveRoutes()
    }
    
    func generateEmoji(for name: String, completion: @escaping (String) -> Void) {
        let apiKey = geminiApiKey
        let prompt = "What emoji best represents '\(name)'?. Give me one emoji in answer nothing else."
        
        // Set up the API request parameters for the Gemini API
        let parameters: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        // Construct the URL
        let url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=\(apiKey)"
        
        // Make the API request
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let value):
                    print("DEBUG - Full response JSON: \(value)")
                    do {
                        if let json = try JSONSerialization.jsonObject(with: value, options: []) as? [String: Any],
                           let candidates = json["candidates"] as? [[String: Any]],
                           let content = candidates.first?["content"] as? [String: Any],
                           let parts = content["parts"] as? [[String: Any]],
                           let text = parts.first?["text"] as? String {
                            let ans = text.trimmingCharacters(in: .whitespacesAndNewlines)
                            completion(ans.count > 1 ? "❓" : ans)
                        } else {
                            print("DEBUG - No emoji found in response structure.")
                            completion("❓")
                        }
                    } catch {
                        print("DEBUG - Error while converting Data to JSON: \(error.localizedDescription)")
                        completion("❓")
                    }
                    
                case .failure(let error):
                    print("DEBUG: \(error.localizedDescription)")
                    completion("❓") // Return a default emoji on error
                }
            }
    }
    
    
    
    
}
