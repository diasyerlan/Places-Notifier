//
//  RoutesRepo.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 22.09.2024.
//

import Foundation

class RoutesRepository: ObservableObject {
    static let shared = RoutesRepository()
    @Published var routes: [Route] = []
    
    private init() {
            loadRoutes()
        }
    
    // MARK: - functions to store and load the data from User Defaults
    func updateRoute(_ route: Route) {
        if let index = routes.firstIndex(where: { $0.id == route.id }) {
            routes[index] = route
        }
    }
    
    func saveRoutes() {
        do {
            let data = try JSONEncoder().encode(routes)
            UserDefaults.standard.set(data, forKey: "savedRoutes")
            print("DEBUG - Routes saved to UserDefaults")

        } catch {
            print("DEBUG - Failed to save routes: \(error.localizedDescription)")
        }
    }
    
    func loadRoutes() {
        if let data = UserDefaults.standard.data(forKey: "savedRoutes") {
            do {
                routes = try JSONDecoder().decode([Route].self, from: data)
                print("DEBUG - Routes loaded from UserDefaults")
            } catch {
                print("DEBUG - Failed to load routes: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(route: Route) {
        if let index = routes.firstIndex(where: { $0.id == route.id }) {
            routes.remove(at: index)
        }
        saveRoutes()
    }
    
    func renameRoute(route: Route, routeName: String) {
        if let index = routes.firstIndex(of: route) {
            routes[index].name = routeName
            print("DEBUG - \(routes[index].name)")
        }
        saveRoutes()
    }
}
