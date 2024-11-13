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
    @State private var showRenameAlert = false
    @State private var routeToRename: Route?
    @StateObject var viewModel = RoutesViewModel()
    
    init() {
        for fm in UIFont.familyNames {
            
            print(fm)
            for fn in UIFont.fontNames(forFamilyName: fm) {
                print("--\(fn)")
            }
        }
        
                // Configure the appearance for the navigation bar
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Comfortaa-Bold", size: 32)!]
        
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Comfortaa-Bold", size: 18)!]

            
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.customGold2, .white]),
                    startPoint: .top,
                    endPoint: .bottom)
                .ignoresSafeArea()
                VStack {
                    routeListView
                }            }
            .navigationTitle("Routes")
            .toolbar {
                settingsButton
            }
            .alert("Enter the route name", isPresented: $showAlert) {
                TextField("Route name", text: $routeName)
                Button("Add") {
                    addRoute()
                }
                Button("Cancel", role: .cancel) {
                    routeName = ""
                }
            }
            .alert("Rename a route", isPresented: $showRenameAlert) {
                TextField("New route name", text: $routeName)
                Button("Save") {
                    if let routeToRename = routeToRename {
                        viewModel.renameRoute(route: routeToRename, routeName: routeName)
                        self.routeToRename = nil
                        routeName = ""
                    }
                }
            }
            .sheet(isPresented: $showAddRoutes) {
                if let selectedRoute = selectedRoute {
                    RouteView(route: selectedRoute)
                }
            }
        }
        .environmentObject(viewModel)
    }

    private var routeListView: some View {
        Group {
            if !viewModel.routes.isEmpty {
                List {
                    ForEach(viewModel.routes, id: \.self) { route in
                        NavigationLink {
                            RouteView(route: route)
                        } label: {
                            routeRow(route: route)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            } else {
                noRoutesPlaceholder
            }
        }
    }

    private var settingsButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12)                    .foregroundStyle(.icon)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 25, height: 25)
                    )
                    .padding(.leading, 8)
                    
            }
        }
    }

    private var noRoutesPlaceholder: some View {
        VStack {
            Text("You have no routes yet")
                .foregroundStyle(.gray)
                .font(.footnote)
            Text("Start your journey by adding your first route!")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
    }

    private func routeRow(route: Route) -> some View {
        HStack {
            Text("\(route.emoji) \(route.name)")
            Spacer()
            Text(route.isActive ? "Active" : "Inactive")
                .font(.caption)
                .foregroundStyle(route.isActive ? .green : .red)
        }
        .swipeActions {
            renameRouteButton(route: route)
            deleteRouteButton(route: route)
        }
    }

    private func renameRouteButton(route: Route) -> some View {
        Button {
            routeToRename = route
            routeName = route.name
            showRenameAlert = true
        } label: {
            Label("Rename", systemImage: "pencil")
        }
        .tint(.blue)
    }

    private func deleteRouteButton(route: Route) -> some View {
        Button(role: .destructive) {
            viewModel.delete(route: route)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    private func addRoute() {
        viewModel.generateEmoji(for: routeName) { emoji in
            let newRoute = Route(name: routeName, places: [], isActive: true, emoji: emoji, activationPeriodType: .singleDay)
            viewModel.routes.append(newRoute)
            viewModel.saveRoutes()
            selectedRoute = newRoute
            showAddRoutes = true
            routeName = ""
        }
    }
}


#Preview {
    HomeView()
}
