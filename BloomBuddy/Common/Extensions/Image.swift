//
//  Image.swift
//  BloomBuddy
//
//  Created by Mia Koring on 26.07.24.
//

import Foundation
import SwiftUI

extension Image {
    func plantImage(size: CGFloat, color: Color, lineWidth: CGFloat) -> some View {
        self
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
