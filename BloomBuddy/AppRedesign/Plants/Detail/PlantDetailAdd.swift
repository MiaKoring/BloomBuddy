//
//  PlantDetail.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI
import Sliders

struct PlantDetailAdd: View {

    // MARK: - Properties
    let collection: PlantCollection
    @Environment(\.dismiss) private var dismiss
    @State var name: String = ""
    @State var size: Double = 100
    @State var watering: WaterRequirement = .small
    
    var edit: Bool = false
    var plant: Plant? = nil

    var valid: Bool {
        name.isNotEmpty && size > 0
    }

    var body: some View {
        BackgroundView(.plantGreen.opacity(0.15)) {
            ScrollView {
                VStack {
                    ZStack {
                        Image("plantBg")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.6)
                            .frame(height: 250.0)
                            .clipped()
                            .overlay {
                                Color.plantGreen.opacity(0.8)
                            }
                        
                        PlantImage(150, "plantBg", color: .constant(.white), lineWidth: 10)
                        
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .font(.Regular.large)
                                    .foregroundStyle(
                                        .plantGreen.darker().opacity(0.8),
                                        .plantGreen.lighter().opacity(0.4)
                                    )
                                    .button {
                                        dismiss()
                                    }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .frame(height: 250.0)
                    
                    VStack(spacing: 20.0) {
                        BBTextField("Name der Pflanze", text: $name)
                        BBNumberField("Größe in cm", value: $size)
                        WaterRequirementButtons(selected: $watering)
                        
                        Spacer()
                        
                        Text("Speichern")
                            .font(.Bold.title)
                            .padding()
                            .frame(maxWidth: .infinity, idealHeight: 60.0)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(valid ? .plantGreen: .gray.opacity(0.4))
                            )
                            .button {
                                if !edit {
                                    create()
                                    return
                                }
                                save()
                            }
                            .disabled(!valid)
                    }
                    .padding()
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .scrollIndicators(.hidden)
        }
        .task {
            if edit, let plant, let name = plant.name, let watering = plant.waterRequirement {
                self.name = name
                self.size = plant.size
                self.watering = WaterRequirement(rawValue: watering) ?? .small
            }
        }
    }
    
    private func create() {
        CoreDataProvider.shared.createPlant(
            name,
            size: size,
            watering: watering,
            collection: collection
        )
        dismiss()
    }
    
    private func save() {
        //TODO: Insert Coredata save
        dismiss()
    }
}
