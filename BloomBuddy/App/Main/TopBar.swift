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
                .font(.title2)
                .bold()
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
                    print("test")
                    showSettings.setTrue()
                }
        }
        .padding(.bottom, 20)
        .fullScreenCover(isPresented: $showSettings) {
            NavigationView<SettingsGroup, Text>() {
                Text("Einstellungen")
            }
        }
    }
}
