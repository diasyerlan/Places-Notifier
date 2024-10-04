//
//  MapViewController.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 22.08.2024.
//

import UIKit

import CoreLocation
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    var mapView: GMSMapView?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var currentMarker: GMSMarker?
    weak var delegate: MapViewControllerDelegate?
    var markers: [GMSMarker] = []
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Initializing the map
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: 43.238949, longitude: 76.889709, zoom: 15.0)
        options.frame = self.view.bounds
        
        mapView = GMSMapView(options: options)
        mapView?.delegate = self
        mapView?.settings.myLocationButton = true
        mapView?.isMyLocationEnabled = true
        self.view.addSubview(mapView!)
        
        // Map constraints
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Initializing the autocomplete
        resultsViewController = GMSAutocompleteResultsViewController()
        
        let filter = GMSAutocompleteFilter()
        let neBoundsCorner = CLLocationCoordinate2D(latitude: 43.3964, longitude: 77.2499)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: 43.0950, longitude: 76.7269)
        
        filter.locationRestriction = GMSPlaceRectangularLocationOption(neBoundsCorner, swBoundsCorner)
        
        resultsViewController?.autocompleteFilter = filter
        
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchController?.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
    
    }
    
    func updateMarkers(places: [Place]) {
            // Clear existing markers
            markers.forEach { $0.map = nil }
            markers.removeAll()
            
            // Add new markers based on the list of places
            for place in places {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                marker.title = place.name
                marker.icon = GMSMarker.markerImage(with: .blue)
                marker.map = mapView
                markers.append(marker) // Store the marker in the array
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.navigationItem.titleView = searchController?.searchBar
        
    }
    
}

extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        if let marker = currentMarker {
            marker.map = nil
        }
        
        // Adding a marker by search
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.map = mapView
        
        mapView?.selectedMarker = marker
        currentMarker = marker
        
        // Animating map to searched place
        let location = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        mapView?.animate(to: location)
        delegate?.didSelect()
        delegate?.selectPlace(place: place.name ?? "Unknown place", coordinate: place.coordinate)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        
    }
    //    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //    }
    //
    //    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //    }
    
}


extension MapViewController: GMSMapViewDelegate {
    // Getting place info by tap
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        currentMarker?.map = nil
        
        // Reverse geocoding for getting place info by tapping
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), error == nil else {
                print("Error in reverse geocoding - \(String(describing: error?.localizedDescription))")
                return
            }
            let markerTitle = address.thoroughfare ?? address.lines?.first ?? "Unknown place"
            let markerSnippet = address.lines?.joined(separator: "\n")
            
            let marker = GMSMarker(position: coordinate)
            marker.title = markerTitle
            marker.snippet = markerSnippet
            marker.map = mapView
            mapView.selectedMarker = marker
            self.currentMarker = marker
            self.delegate?.didSelect()
            self.delegate?.selectPlace(place: markerTitle, coordinate: coordinate)
            
        }
    }
    // Removing the marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.map = nil
        currentMarker = nil
        delegate?.didDeselect()
        return true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                currentLocation = location
                
                // Update the map's camera to center on the user's current location
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
                mapView?.animate(to: camera)
                
                // Stop updating location after getting the current one
                locationManager.stopUpdatingLocation()
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error: \(error.localizedDescription)")
        }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            showLocationAccessDeniedAlert()
        }
        return true
    }
    
    func showLocationAccessDeniedAlert() {
            let alertController = UIAlertController(
                title: "Location Access Denied",
                message: "Please enable location access in Settings to use this feature.",
                preferredStyle: .alert
            )
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    
}
