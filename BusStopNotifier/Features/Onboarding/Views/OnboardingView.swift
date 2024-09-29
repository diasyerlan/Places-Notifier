//
//  OnboardingView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 04.08.2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    @Namespace private var animation
    
    var body: some View {
        if currentPage == 1 {
            OnboardingReusableView(image: "animation1", title: "Set Your Route", subHeading: "Easily select your daily bus route to stay informed about nearby stops and destinations",   namespace: animation)
        }
        if currentPage == 2 {
            OnboardingReusableView(image: "animation2", title: "Get Notified in Time", subHeading: "Receive timely alerts when your destination is approaching, so you’ll never miss your stop again" ,  namespace: animation)
        }
        if currentPage == 3 {
            OnboardingReusableView(image: "animation3", title: "Customize Your Notifications", subHeading: "Choose how and when you want to be notified, whether by sound or phone call" ,  namespace: animation)
        }
        if currentPage == 4 {
            HomeView()
        }
    }
}

#Preview {
    OnboardingView()
}
