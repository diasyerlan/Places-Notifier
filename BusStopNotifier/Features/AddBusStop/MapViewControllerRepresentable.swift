//
//  MapViewControllerRepresentable.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 22.08.2024.
//

import Foundation
import SwiftUI

struct MapViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var isPlaceSelected: Bool
    @Binding var selectedPlace: String

    func makeUIViewController(context: Context) -> some UIViewController {
        let mapViewController = MapViewController()
        mapViewController.delegate = context.coordinator
        return mapViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
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
        
        func selectPlace(place: String) {
            parent.selectedPlace = place
        }
        
    }
}

protocol MapViewControllerDelegate: AnyObject {
    func didSelect()
    func didDeselect()
    func selectPlace(place: String)
}
