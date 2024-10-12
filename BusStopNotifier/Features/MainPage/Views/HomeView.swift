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
    @Environment(\.colorScheme) var colorScheme

    private let appearanceKey = "appearance"
    @State private var isDarkMode: Bool = UserDefaults.standard.object(forKey: "appearance") as? Bool ?? false

    @StateObject var viewModel = RoutesViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                routeListView
            }
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                settingsButton
                addRouteButton
            }
            .alert("Enter the route name", isPresented: $showAlert) {
                TextField("Route name", text: $routeName)
                Button("Add") {
                    viewModel.generateEmoji(for: routeName) { emoji in
                        let newRoute = Route(name: routeName, places: [], isActive: true, emoji: emoji, activationPeriodType: .singleDay)
                        viewModel.routes.append(newRoute)
                        viewModel.saveRoutes()
                        selectedRoute = newRoute
                        showAddRoutes = true
                        routeName = ""
                    }
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
                    RouteView(route: selectedRoute, isDarkMode: isDarkMode)
                }
            }
        }
        .onAppear {
            if UserDefaults.standard.object(forKey: appearanceKey) == nil {
                isDarkMode = colorScheme == .dark
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onChange(of: isDarkMode) { _, newValue in
            UserDefaults.standard.set(newValue, forKey: appearanceKey)
        }
        .onChange(of: colorScheme) { _,newColorScheme in
                        isDarkMode = newColorScheme == .dark
                    }
        .animation(.easeInOut, value: isDarkMode)
        .environmentObject(viewModel)
    }

    private var routeListView: some View {
        Group {
            if !viewModel.routes.isEmpty {
                List {
                    ForEach(viewModel.routes, id: \.self) { route in
                        NavigationLink {
                            RouteView(route: route, isDarkMode: isDarkMode)
                        } label: {
                            routeRow(route: route)
                        }
                    }
                }
            } else {
                noRoutesPlaceholder
            }
        }
    }

    private var settingsButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink {
                SettingsView(isDarkMode: $isDarkMode)
            } label: {
                Image(systemName: "gear")
                    .foregroundStyle(.customGold)
            }
        }
    }

    private var addRouteButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAlert = true
            } label: {
                Text("Add")
                    .foregroundStyle(.customGold)
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
}


#Preview {
    HomeView()
}
