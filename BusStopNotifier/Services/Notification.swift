//
//  Notification.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 23.09.2024.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Notifications permission request
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("DEBUG - Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Notification sending function
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
    
    // MARK: - UNUserNotificationCenterDelegate method to handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display notification even if app is in the foreground
        completionHandler([.banner, .sound])
    }
}
