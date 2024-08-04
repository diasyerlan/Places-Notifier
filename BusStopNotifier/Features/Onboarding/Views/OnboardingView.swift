//
//  OnboardingView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 04.08.2024.
//

import SwiftUI

var totalPages = 2
struct OnboardingView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    @Namespace private var animation
    
    var body: some View {
        if currentPage == 1 {
            OnboardingReusableView(image: "animation1", title: "Add Bus Stops", subHeading: "You can select any bus stop in your city with the help of the map view to get notified",   namespace: animation)
        }
        if currentPage == 2 {
            OnboardingReusableView(image: "animation2", title: "Manage freely", subHeading: "You are able to manage added bus stops by adding, disabling or deleting them" ,  namespace: animation)
        }
        if currentPage == 3 {
            HomeView()
        }
    }
}

#Preview {
    OnboardingView()
}
