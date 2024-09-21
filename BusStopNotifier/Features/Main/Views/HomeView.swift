//
//  HomeView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 04.08.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var showAddRoutes = false
    @State private var showAlert = false
    @State private var routeName = ""
    @State private var selectedRoute: Route?
    @StateObject var viewModel = RoutesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.routes.isEmpty {
                    List(viewModel.routes, id: \.self) { route in
                        NavigationLink {
                            RouteView(route: route)
                        } label: {
                            HStack {
                                Text(route.name)
                                Spacer()
                                Text(route.isActive ? "Active" : "Inactive")
                                    .font(.caption)
                                    .foregroundStyle(route.isActive ? .green : .red)
                            }
                        }
                        
                    }
                } else {
                    Text("You have no routes yet")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    Text("Start your journey by adding your first route!")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)                }
            }
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {} label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.customGold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAlert = true
                    } label: {
                        Text("Add")
                            .foregroundStyle(.customGold)
                    }
                }
            }
            .alert("Enter the route name", isPresented: $showAlert) {
                TextField("Route name", text: $routeName)
                Button("Add") {
                    let newRoute = Route(name: routeName, places: [], isActive: true)
                    viewModel.routes.append(newRoute)
                    viewModel.saveRoutes()
                    selectedRoute = newRoute
                    routeName = ""
                    print(viewModel.routes)
                    showAddRoutes = true
                }
                Button("Cancel", role: .cancel) {
                    routeName = ""
                }
            }
            .sheet(isPresented: $showAddRoutes, content: {
                RouteView(route: selectedRoute!)
            })
        }
        .environmentObject(viewModel)

        
    }
}

#Preview {
    HomeView()
}
