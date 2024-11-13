//
//  ContentView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 12.11.2024.
//

import SwiftUI

struct TabBar: Identifiable {
    var id = UUID()
    var iconName: String
    var tab: TabIcon
    var index: Int
}

let tabItems = [TabBar(iconName: "square.stack", tab: .Home, index: 0), TabBar(iconName: "calendar", tab: .Scheduled, index: 1), TabBar(iconName: "plus.app.fill", tab: .Add, index: 2), TabBar(iconName: "bell", tab: .Notifications, index: 3), TabBar(iconName: "magnifyingglass", tab: .Search, index: 4)]

enum TabIcon: String {
    case Home
    case Scheduled
    case Add
    case Notifications
    case Search
}

struct ContentView: View {
    @State var selectedTab: TabIcon = .Home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(TabIcon.Home)
                ScheduledTasksView()
                    .tag(TabIcon.Scheduled)
                NotificationsView()
                    .tag(TabIcon.Notifications)
                SearchView()
                    .tag(TabIcon.Search)
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        }
}

#Preview {
    ContentView()
}


struct CustomTabBar: View {
    @Binding var selectedTab: TabIcon
    @State var xOffset = 0 * 70.0
    
    var body: some View {
        HStack {
            ForEach(tabItems) { item in
                Spacer()
                if item.tab == .Add {
                    Image(systemName: item.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundStyle(.black)
                        .onTapGesture {
                            print("YEAAH")
                        }
                }
                else {
                    Image(systemName: item.iconName).foregroundStyle(selectedTab == item.tab ? .black : .icon)
                        .onTapGesture {
                            withAnimation(.spring) {
                                selectedTab = item.tab
                                xOffset = CGFloat(item.index) * 70
                            }
                            print("\(item.tab)")
                        }
                }
                Spacer()
                
                
            }
            .frame(width: 23.3)
        }
        .frame(height: 70)
        .background(.tabBar, in: RoundedRectangle(cornerRadius: 10))
        .overlay(alignment: .bottomLeading) {
            Circle().frame(width: 10, height: 10).foregroundStyle(.black)
                .offset(x: 30, y: -5)
                .offset(x: xOffset)
        }
    }
}
