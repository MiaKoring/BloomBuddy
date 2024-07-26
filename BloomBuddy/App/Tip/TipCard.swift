//
//  TipCard.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI

struct TipCard: View {

    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Tipp des Tages")
                        .font(.Bold.title)

                    Text("Hochbeete richtig anlegen \n3 Tipps für das beste Klima.")
                        .font(.system(size: 16.0, weight: .light))
                }
                .padding(.horizontal, 30.0)
                .padding(.vertical, 30)

                Spacer()
            }
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .font(.Regular.regular)
                            .foregroundStyle(.white.opacity(0.5))
                            .button {
                                UDKey.tips.boolValue.setFalse()
                            }
                    }
                    .padding(10.0)
                    Spacer()

                    HStack {
                        Spacer()
                        Image(systemName: "chevron.right.circle")
                            .font(.system(size: 38, weight: .light))
                            .foregroundStyle(.white)
                            .button {

                            }
                    }
                    .padding([.trailing, .bottom])
                }
            }
        }
        .foregroundStyle(.white)
        .background(
            Image("plantBg")
                .resizable()
                .scaledToFill()
                .opacity(0.6)
                .overlay(content: {
                    Color.plantGreen.opacity(0.8)
                })
        )
        .clipShape(.rect(cornerRadius: 20.0))
    }
}
