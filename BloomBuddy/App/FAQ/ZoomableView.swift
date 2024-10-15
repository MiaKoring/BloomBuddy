//
//  ZoomableView.swift
//  BloomBuddy
//
//  Created by Mia Koring on 27.08.24.
//

import SwiftUI
import Kingfisher

struct ZoomableView: View {
    let url: String
    let size: CGSize
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State var showFailed = false
    @State private var currentOffset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        if !showFailed {
            KFImage(URL(string: url))
                .placeholder { progress in
                    Rectangle()
                        .fill(.gray)
                        .frame(width: size.width, height: size.height)
                        .shimmering()
                }
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .retry(maxCount: 3, interval: .seconds(2))
                .resizable()
                .onFailure {_ in showFailed.setTrue() }
                .scaledToFit()
                .scaleEffect(currentScale)
                .offset(x: currentOffset.width, y: currentOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.currentOffset = CGSize(
                                width: self.lastOffset.width + value.translation.width,
                                height: self.lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            self.lastOffset = self.currentOffset
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let res = self.lastScale * value
                            switch res {
                            case 0.8..<1.4:
                                withAnimation(.spring()) {
                                    self.currentScale = 1
                                }
                            case 1.4...4:
                                self.currentScale = res
                            default: return
                            }
                        }
                        .onEnded { value in
                            self.lastScale = self.currentScale
                        }
                )
                .gesture(TapGesture(count: 2).onEnded {
                    withAnimation(.spring(duration: 0.2)) {
                        if self.currentScale >= 2 {
                            self.currentScale = 1
                            self.lastScale = 1
                        } else {
                            self.currentScale = 2.5
                            self.lastScale = 2.5
                        }
                    }
                })
        } else {
            Text("Laden fehlgeschlagen")
                .font(.Bold.regular)
        }
    }
}

