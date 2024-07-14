//
//  ContentView.swift
//  HackathonProject1
//
//  Created by Mia Koring on 14.07.24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                let data = try await Network.request(Weather.self, environment: .weather, endpoint: WeatherAPI.forecast(48.8, 8.3333))
                print(data)
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MainView()
}
