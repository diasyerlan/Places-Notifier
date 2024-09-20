//
//  MapView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 26.08.2024.
//

import SwiftUI

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    var route: Route
    @State private var selectedPlace = ""
    @State private var isPlaceSelected = false
    var body: some View {
        NavigationStack {
            MapViewControllerRepresentable(isPlaceSelected: $isPlaceSelected, selectedPlace: $selectedPlace)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            route.places.append(selectedPlace)
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
    MapView(route: Route(name: "", places: [], isActive: true))
}
