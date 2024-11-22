//
//  NavigationButton.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//

import SwiftUI

struct NavigationButton: View {
    let image: Image
    let title: String
    var imageWidth: CGFloat = 20
    var body: some View {
        HStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageWidth, height: imageWidth)
                .padding(.horizontal, (40 - imageWidth) / 2)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .padding(.trailing, 7)
        }
        .padding(.vertical, (30 - imageWidth) / 2)
    }
}
