//
//  MapViewController.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 22.08.2024.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController{
    
    var mapView: GMSMapView?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var currentMarker: GMSMarker?
    weak var delegate: MapViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializing the map
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: 43.238949, longitude: 76.889709, zoom: 15.0)
        options.frame = self.view.bounds
        
        mapView = GMSMapView(options: options)
        mapView?.delegate = self
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
        delegate?.selectPlace(place: place.name ?? "Unknown place")
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
            self.delegate?.selectPlace(place: markerTitle)

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
