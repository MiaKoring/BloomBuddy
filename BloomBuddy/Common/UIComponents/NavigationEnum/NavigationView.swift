//
//  Untitled.swift
//  BloomBuddy
//
//  Created by Mia Koring on 22.11.24.
//

import SwiftUI

struct NavigationView<T, Content: View>: View where T: NavigationGroups, T.AllCases: RandomAccessCollection {
    @Environment(\.dismiss) var dismiss
    let title: () -> Content
    var body: some View {
        NavigationStack {
            BackgroundView(.plantGreen.opacity(0.15)) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .button {
                                dismiss()
                            }
                        title()
                            .font(.Bold.heading1)
                    }
                    .padding(.bottom)
                    ForEach(T.allCases, id: \.self) { group in
                        if let sectionTitle = group.title {
                            Text(sectionTitle)
                                .font(.caption)
                                .foregroundStyle(.primary.opacity(0.5))
                        }
                        VStack {
                            ForEach(group.children, id: \.self) { child in
                                NavigationLink {
                                    BackgroundView(.plantGreen.opacity(0.15)) {
                                        child.view
                                    }
                                    .navigationTitle(Text(child.destinationTitle))
                                } label: {
                                    child.button
                                }
                                .foregroundStyle(.primary)
                                if child != group.children.last {
                                    if !child.fullDivider {
                                        Divider()
                                            .padding(.leading, 50)
                                    } else {
                                        Divider()
                                    }
                                }
                            }
                        }
                        .padding(7)
                        .frame(maxWidth: .infinity)
                        .background() {
                            Rectangle()
                                .fill(.regularMaterial)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    BackgroundView(.plantGreen.opacity(0.15)) {
        NavigationView<SettingsGroup, Text>() {
            Text("Einstellungen")
        }
    }
}
