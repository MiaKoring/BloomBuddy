//
//  FAQImage.swift
//  BloomBuddy
//
//  Created by Mia Koring on 27.08.24.
//

import SwiftUI
import Kingfisher

struct FAQImageView: View {
    let image: FAQImage
    @State var showAlt: Bool = false
    let size: CGSize
    @State var enableDetail = false
    @State var showDetail = false
    init(image: FAQImage) {
        self.image = image
        self.size = {
            let ratio = image.width.double / image.height.double
            if ratio <= 1 {
                return CGSize(width: 350 / ratio, height: 350)
            } else {
                return CGSize(width: 350, height: 350 / ratio)
            }
        }()
    }
    var body: some View {
        VStack {
            if !showAlt {
            KFImage(URL(string: image.url))
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
                .onFailure {_ in showAlt.setTrue() }
                .onSuccess { _ in enableDetail.setTrue() }
                .scaledToFit()
                .frame(maxWidth: 350, maxHeight: 350)
                .onTapGesture {
                    if enableDetail { showDetail.setTrue() }
                }
        } else {
            Text(image.alt)
                .padding()
                .frame(width: size.width, height: size.height)
                .overlay {
                    Rectangle()
                        .stroke(.plantGreen, lineWidth: 2)
                }
                .padding(.horizontal)
        }
        Text(image.subtitle)
            .foregroundStyle(.gray)
            .font(.Bold.regularSmall)
    }
    .sheet(isPresented: $showDetail) {
        VStack {
            Text(image.title)
                .font(.Bold.heading1)
                .foregroundStyle(.gray)
                .padding()
            Spacer()
            ZoomableView(url: image.url, size: size)
            Spacer()
        }
        .presentationDragIndicator(.visible)
    }
}
}

