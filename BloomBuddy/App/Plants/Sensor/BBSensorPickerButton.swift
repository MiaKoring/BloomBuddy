//
//  BBPicker.swift
//  BloomBuddy
//
//  Created by Mia Koring on 24.08.24.
//

import Foundation
import SwiftUI
import SwiftChameleon

struct BBSensorPickerButton: View {
    let placeholder: LocalizedStringKey
    let options: [SensorIdentifier]
    @Binding var selected: SensorIdentifier?
    @State var showList: Bool = false
    @State var showSensorDetailAdd: Bool = false
    let refreshSensors: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(placeholder)
                    .font(.Bold.regularSmall)
                    .foregroundStyle(.gray)
                Spacer()
                Image(systemName: "plus")
                    .foregroundStyle(.gray)
                    .font(.Bold.regularSmall)
                    .button {
                        showSensorDetailAdd = true
                    }
            }
            .padding(.horizontal)
            HStack {
                Text(selected?.name ?? "Keiner")
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
            }
            .font(.Bold.title2)
            .foregroundStyle(.plantGreen)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(.plantGreen.opacity(0.1))
            )
            .tint(.plantGreen)
            .onTapGesture {
                showList = true
            }
        }
        .sheet(isPresented: $showList) {
            SensorList(selected: $selected, options: options)
        }
        .sheet(isPresented: $showSensorDetailAdd, onDismiss: refreshSensors) {
            SensorDetailAdd()
                .padding(20)
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            BBSensorPickerButton(placeholder: "Sensor", options: [], selected: .constant(nil)) {}
        }
    }
}
