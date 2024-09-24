//
//  SettingsView.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 24.09.2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: RoutesViewModel
    let options = [200, 300, 400, 500]
    @Binding var isDarkMode: Bool
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    Toggle(isOn: $viewModel.notifyByCall) {
                        Text("Notify by call")
                    }
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark mode")
                    }
                    Picker("Notification distance", selection: $viewModel.distance) {
                        ForEach(options, id: \.self) { option in
                            Text("\(option) m").tag(option)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
