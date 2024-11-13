//
//  RouteView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 21.08.2024.
//

import SwiftUI

struct RouteView: View {
    @ObservedObject var route: Route
    @EnvironmentObject var routeViewModel: RoutesViewModel
    @StateObject var placeViewModel: PlacesViewModel
    @State private var showRenameAlert = false
    @State private var placeToRename: Place?
    @State private var placeName = ""
    
    init(route: Route) {
            self.route = route
            _placeViewModel = StateObject(wrappedValue: PlacesViewModel(route: route))
        }
    var body: some View {
        NavigationStack {
            VStack {
                
                if route.places.isEmpty {
                    Spacer()
                    Text("Add places to get notified")
                } else {
                    List {
                        ForEach(route.places, id: \.self) { place in
                            HStack {
                                Text(place.name)
                                Spacer()
                                Text(place.isReached ? "Reached": "Not Reached")
                                    .font(.footnote)
                                    .foregroundStyle(place.isReached ? .green : Color(.systemGray))
                            }
                            .swipeActions {
                                Button {
                                    placeToRename = place
                                    placeName = place.name
                                    showRenameAlert = true
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                                .tint(.blue)
                                
                                // Delete option
                                Button(role: .destructive) {
                                    placeViewModel.delete(place: place)
                                    routeViewModel.saveRoutes()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        MapView(route: route)
                            .ignoresSafeArea()
                        
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .background(Circle().fill(.customGold))
                            .padding()
                    }
                }
            }
            .navigationTitle(route.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink { RouteSettingsView(route: route) } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.black)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        route.isActive.toggle()
                        routeViewModel.updateRoute(route)
                    } label: {
                        Text(route.isActive ? "Deactivate" : "Activate")
                            .foregroundStyle(route.isActive ? .red : .green)
                    }
                }
            }
            .alert("Rename a place", isPresented: $showRenameAlert) {
                TextField("New place name", text: $placeName)
                Button("Save") {
                    placeViewModel.rename(place: placeToRename!, placeName: placeName)
                    placeToRename = nil
                    placeName = ""
                    routeViewModel.saveRoutes()
                }
            }
        }
    }
}

#Preview {
    RouteView(route: Route(name: "", places: [], isActive: true, emoji: "🤖", activationPeriodType: .singleDay))
}
