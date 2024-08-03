//
//  WeatherScreen.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import WeatherKit

struct WeatherScreen: View {
    // MARK: - Properties
    let weather: Weather

    var body: some View {
        VStack(spacing: 20) {
            WeatherCard(weather: weather)
            WeatherExtraInfo(weather: weather)
        }
    }
}
