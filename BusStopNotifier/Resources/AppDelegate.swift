//
//  AppDelegate.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 07.08.2024.
//

import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBn01OK7-X-171PUdzQiKl09rpN5Zn6pq8")
        GMSPlacesClient.provideAPIKey("AIzaSyBn01OK7-X-171PUdzQiKl09rpN5Zn6pq8")
        return true
    }
}
