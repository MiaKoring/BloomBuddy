//
//  BackgroundView.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI

struct BackgroundView<C: View, B: ShapeStyle>: View {
    let content: C
    let background: B

    init(_ background: B, @ViewBuilder content: () -> C) {
        self.content = content()
        self.background = background
    }

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
                .background(background)

            content
        }
    }
}
