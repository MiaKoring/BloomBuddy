//
//  FAQDestination.swift
//  BloomBuddy
//
//  Created by Mia Koring on 27.08.24.
//

import SwiftUI
import Kingfisher

struct FAQDestination: View {
    let type: FAQ
    @State var components: [FAQComponent] = [FAQComponent(title: "Test", paragraph: "Testp", image: .init(url: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Test-Logo.svg/1566px-Test-Logo.svg.png", title: "Test", alt: "Testbild", subtitle: "TestImage", width: 1566, height: 719))]
    var body: some View {
        ScrollView {
            VStack {
                ForEach(components, id: \.self) { comp in
                    VStack {
                        Text(comp.title)
                            .font(.Bold.title)
                        Text(comp.paragraph)
                        if let image = comp.image {
                            FAQImageView(image: image)
                        }
                    }
                }
            }
        }
    }
}
