//
//  ShimneringSkeletonModifier.swift
//  BloomBuddy
//
//  Created by Mia Koring on 27.08.24.
//

import SwiftUI

struct ShimmeringSkeletonModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .modifier(AnimatedMask(phase: phase))
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

struct AnimatedMask: AnimatableModifier {
    var phase: CGFloat
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .mask(
                GradientMask(phase: phase)
                    .scaleEffect(3)
            )
    }
}

struct GradientMask: View {
    let phase: CGFloat
    let centerColor = Color.black.opacity(0.5)
    let edgeColor = Color.black.opacity(1)
    
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(stops: [
                .init(color: edgeColor, location: phase),
                .init(color: centerColor, location: phase + 0.1),
                .init(color: edgeColor, location: phase + 0.2)
            ], startPoint: UnitPoint(x: 0, y: 0.5), endPoint: UnitPoint(x: 1, y: 0.5))
            .rotationEffect(.degrees(-45))
            .offset(x: -geometry.size.width, y: -geometry.size.height)
            .frame(width: geometry.size.width * 3, height: geometry.size.height * 3)
        }
    }
}
