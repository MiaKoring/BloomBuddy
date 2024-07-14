//
//  TipsView.swift
//  HackathonProject1
//
//  Created by Amelie Meyer on 14/07/24.
//

import SwiftUI

struct TipsView: View {
    var tips: [String] = [
        "Gieße am Besten frühmorgens vor Sonnenaufgang zwischen 4 und 6 Uhr!",
        "Gieße lieber seltener, wenn dann mehr auf einmal!",
        "Gieße so lange, bis der Boden gut durchnässt ist, sich aber noch keine Staunässe bildet!"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Allgemeine Tipps zum Gießen")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                ForEach(tips, id: \.self) { tip in
                    HStack(alignment: .top) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(.yellow.gradient)
                            .font(.title)
                            .padding(.trailing, 10)
                        
                        Text(tip)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.vertical, 5)
                }
            }
            .padding()
        }
        .navigationTitle("Tips")
    }
}

#Preview {
    TipsView()
}
