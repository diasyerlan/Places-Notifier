//
//  MapView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 26.08.2024.
//

import SwiftUI
import CoreLocation

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RoutesViewModel
    var route: Route
    @State private var selectedPlace = ""
    @State private var coordinate: CLLocationCoordinate2D? = nil
    @State private var isPlaceSelected = false
    var body: some View {
        NavigationStack {
            MapViewControllerRepresentable(isPlaceSelected: $isPlaceSelected, selectedPlace: $selectedPlace, coordinate: $coordinate, places: route.places)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            route.places.append(Place(name: selectedPlace, isReached: false, coordinate: coordinate!))
                            viewModel.saveRoutes()
                            dismiss()
                        } label: {
                            Text("Next")
                        }
                        .disabled(!isPlaceSelected)
                    }
                }
        }
    }
}

#Preview {
    MapView(route: Route(name: "", places: [], isActive: true, emoji: "🤖", activationPeriodType: .singleDay))
}
