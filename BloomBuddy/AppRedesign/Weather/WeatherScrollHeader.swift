//
//  WeatherScrollHeader.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI

struct WeatherScrollHeader: View {

    @Binding var scrollPosition: CGPoint

    var body: some View {
        VStack {
            HStack {
                HStack(alignment: .top, spacing: 0.0) {
                    Text("24")
                        .font(.Bold.large)
                        .foregroundStyle(.white.opacity(0.9).gradient)

                    Text("°C")
                        .font(.Regular.title)
                        .padding(.top, 5.0)
                        .foregroundStyle(.white.opacity(0.9).gradient)
                }
                .frame(maxWidth: .infinity)

                Text("DE - Hamburg")
                    .foregroundStyle(.white)
                    .font(.Bold.regularSmall)
                    .frame(maxWidth: .infinity)

                Image(systemName: "sun.max.fill")
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
