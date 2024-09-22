//
//  BusStopNotifierApp.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 04.08.2024.
//

import SwiftUI

@main
struct BusStopNotifierApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let shared = RoutesRepository.shared
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
