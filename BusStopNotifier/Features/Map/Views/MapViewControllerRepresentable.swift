//
//  MapViewControllerRepresentable.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 22.08.2024.
//

import Foundation
import SwiftUI
import CoreLocation

struct MapViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var isPlaceSelected: Bool
    @Binding var selectedPlace: String
    @Binding var coordinate: CLLocationCoordinate2D?
    var places: [Place]

    func makeUIViewController(context: Context) -> some UIViewController {
        let mapViewController = MapViewController()
        mapViewController.delegate = context.coordinator
        return mapViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let mapViewController = uiViewController as? MapViewController else { return }
            
            // Update the markers on the map when places change
            mapViewController.updateMarkers(places: places)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MapViewControllerDelegate {
        
        var parent: MapViewControllerRepresentable
        init(parent: MapViewControllerRepresentable) {
            self.parent = parent
        }
        
        func didSelect() {
            parent.isPlaceSelected = true
        }
        
        func didDeselect() {
            parent.isPlaceSelected = false
        }
        
        func selectPlace(place: String, coordinate: CLLocationCoordinate2D) {
            parent.selectedPlace = place
            parent.coordinate = coordinate
        }
        
        func updateMarkers(places: [Place]) {
        }
    }
}

protocol MapViewControllerDelegate: AnyObject {
    func didSelect()
    func didDeselect()
    func selectPlace(place: String, coordinate: CLLocationCoordinate2D)
    func updateMarkers(places: [Place])
}
