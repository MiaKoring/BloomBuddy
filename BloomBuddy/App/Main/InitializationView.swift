//
//  InitializationView.swift
//  BloomBuddy
//
//  Created by Mia Koring on 17.07.24.
//

import Foundation
import SwiftUI
import RealmSwift
import SwiftChameleon

struct InitializationView: View {
    @ObservedResults(SavedPlant.self) var savedPlants
    @State var showInitFailed: Bool = false
    @Binding var skipInit: Bool
    
    var body: some View {
        VStack {
            Text("App wird eingerichtet...")
            ProgressView()
                .progressViewStyle(.circular)
        }
        .onAppear(perform: setup)
        .alert("Einrichten fehlgeschlagen", isPresented: $showInitFailed) {
            Button {
                setup()
            } label: {
                Text("Erneut versuchen")
            }
            Button {
                setSkipInit()
            } label: {
                Text("Fortfahren")
            }
        }
    }
    
    private func setup() {
        guard let plants = try? JSONHandler.load("ExistingPlants")?.decode([Plant].self) else {
            showInitFailed.setTrue()
            return
        }
        
        for plant in plants {
            let growthStage: GrowthStage = GrowthStage(rawValue: plant.growthStage) ?? .medium
            let waterRequirement: WaterRequirement = WaterRequirement(rawValue: plant.waterRequirement) ?? .medium
            
            $savedPlants.append(SavedPlant(name: plant.name, growthStage: growthStage, waterRequirement: waterRequirement))
        }
        setSkipInit()
    }
    
    func setSkipInit() {
        UserDefaults().setValue(true, forKey: "skipInit")
        skipInit.setTrue()
    }
}
