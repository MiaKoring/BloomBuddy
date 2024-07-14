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
            WeatherCardView()
                .frame(alignment: .top)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainView()
}
