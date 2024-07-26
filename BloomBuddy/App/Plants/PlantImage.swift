//
//  PlantImage.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI

struct PlantImage: View {

    // MARK: - Properties
    let size: CGFloat
    let imageName: String
    @Binding var color: Color
    let lineWidth: CGFloat

    init(_ size: CGFloat, _ imageName: String, color: Binding<Color>, lineWidth: CGFloat = 8) {
        self.size = size
        self.imageName = imageName
        self._color = color
        self.lineWidth = lineWidth
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(.circle)
            .background(
                Circle()
                    .fill(color.gradient)
                    .frame(width: size + lineWidth, height: size + lineWidth)
            )
    }
}
