//
//  RoutesViewModel.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 21.08.2024.
//

import Foundation

class RoutesViewModel: ObservableObject {
    @Published var routes: [Route] = []
    
    func updateRoute(_ route: Route) {
            if let index = routes.firstIndex(where: { $0.id == route.id }) {
                routes[index] = route
            }
        }
}
