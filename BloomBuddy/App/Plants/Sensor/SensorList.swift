//
//  SensorList.swift
//  BloomBuddy
//
//  Created by Mia Koring on 24.08.24.
//

import Foundation
import SwiftUI

struct SensorList: View {
    @Binding var selected: SensorIdentifier?
    let options: [SensorIdentifier]
    var body: some View {
        List {
            HStack {
                Text("Keiner")
                    .foregroundStyle(.plantGreen)
                Spacer()
                if selected.isNil {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.plantGreen.opacity(0.8))
                }
            }
            .font(.Bold.title2)
            .background(.background)
            .onTapGesture {
                selected = nil
            }
                
            ForEach(options) { sensor in
                HStack {
                    Text(sensor.name)
                        .foregroundStyle(.plantGreen)
                    Spacer()
                    if selected?.id == sensor.id {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.plantGreen.opacity(0.8))
                    }
                }
                .font(.Bold.title2)
                .background(.background)
                .onTapGesture {
                    selected = sensor
                }
            }
        }
        .padding(.top, 20)
        .padding(.trailing, 20)
        .listStyle(.inset)
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.visible)
    }
}
