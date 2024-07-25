//
//  WeatherScrollHeader.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import WeatherKit
import ZapdosKit

struct WeatherScrollHeader: View {

    @Environment(LocationManager.self) private var locationManager
    @Binding var scrollPosition: CGPoint
    let weather: Weather

    var body: some View {
        VStack {
            HStack {
                HStack(alignment: .top, spacing: 0.0) {
                    Text("\(weather.intCurrentTemp)")
                        .font(.Bold.large)
                        .foregroundStyle(.white.opacity(0.9).gradient)

                    Text("°C")
                        .font(.Regular.title)
                        .padding(.top, 5.0)
                        .foregroundStyle(.white.opacity(0.9).gradient)
                }
                .frame(maxWidth: .infinity)

                Text("\(locationManager.city)")
                    .foregroundStyle(.white)
                    .font(.Bold.regularSmall)
                    .frame(maxWidth: .infinity)

                Image(systemName: weather.currentWeather.symbolName + ".fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.Regular.large)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .padding(.bottom, 10.0)
            .background(.plantGreen.gradient)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .opacity(scrollPosition.y > -96.9 ? 0.0: 1.0)
        .animation(.easeInOut(duration: 0.3), value: scrollPosition)
    }
}
