//
//  WeatherIconView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI

struct WeatherIconView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color("Sun").opacity(0.6),
                            .white
                        ],
                        center: .center,
                        startRadius: 85,
                        endRadius: 60
                    )
                )
                .frame(width: 170)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color("Sun").opacity(0.8), .white],
                        center: .center,
                        startRadius: 60,
                        endRadius: 40
                    )
                )
                .frame(width: 120)
            Circle()
                .fill(.yellow.secondary)
                .frame(width: 70)
        }
    }
}
