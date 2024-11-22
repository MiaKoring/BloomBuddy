//
//  TopBar.swift
//  BloomBuddy
//
//  Created by Mia Koring on 20.11.24.
//

import SwiftUI

struct TopBar: View {
    @State var showSettings: Bool = false
    var body: some View {
        HStack {
            Text("BloomBuddy")
                .font(.Bold.title)
            Spacer()
            Circle()
                .fill(.plantGreen.opacity(0.2))
                .frame(width: 40)
                .overlay {
                    Image(systemName: "gear")
                        .foregroundStyle(.plantGreen)
                        .font(.Bold.title2)
                        .allowsHitTesting(false)
                }
                .button {
                    showSettings.setTrue()
                }
        }
        .padding(.bottom, 14)
        .fullScreenCover(isPresented: $showSettings) {
            FAQNavigation()
        }
    }
}
