//
//  RouteSettingsView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 24.09.2024.
//

import SwiftUI

struct RouteSettingsView: View {
    @ObservedObject var route: Route
    @State private var selectedActivation: RouteActivationPeriod = .singleDay
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Select Route Activation")
                    .font(.headline)
                
                Picker("Activation", selection: $selectedActivation) {
                    ForEach(RouteActivationPeriod.allCases) { activation in
                        Text(activation.rawValue).tag(activation)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedActivation) { _, newValue in
                    route.activationPeriodType = newValue
                    route.updateActivationStatus()
                }
                
                Spacer()
            }
            .padding()

        }
        .navigationTitle("Route settings")
    }
}

#Preview {
    RouteSettingsView(route: Route(name: "", places: [], isActive: true, activationPeriodType: .singleDay))
}
