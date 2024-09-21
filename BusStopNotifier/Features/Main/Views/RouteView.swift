//
//  RouteView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 21.08.2024.
//

import SwiftUI

struct RouteView: View {
    @ObservedObject var route: Route
    @EnvironmentObject var viewModel: RoutesViewModel
    var body: some View {
        NavigationStack {
            VStack {
                
                if route.places.isEmpty {
                    Spacer()
                    Text("Add places to get notified")
                } else {
                    List(route.places, id: \.self) { place in
                        HStack {
                            Text(place.name)
                            Spacer()
                            Text(place.isReached ? "Reached": "Not Reached")
                                .font(.footnote)
                                .foregroundStyle(place.isReached ? .green : Color(.systemGray))
                        }
                    }.listStyle(.plain)
                }
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        MapView(route: route)
                            .ignoresSafeArea()
//                            .onAppear {
//                                print("DEBUG - \(route.places)")
//                            }
                        
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundStyle(.customGold)
                            .background(Circle().stroke(Color.customGold, lineWidth: 5))
                            .padding()
                    }
                }
            }
            .navigationTitle(route.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        route.isActive.toggle()
                        viewModel.updateRoute(route)
                    } label: {
                        Text(route.isActive ? "Deactivate" : "Activate")
                            .foregroundStyle(route.isActive ? .red : .green)
                    }
                }
            }
        }
    }
}

#Preview {
    RouteView(route: Route(name: "", places: [], isActive: true))
}
