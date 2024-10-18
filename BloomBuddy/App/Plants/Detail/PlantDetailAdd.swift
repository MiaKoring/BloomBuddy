//
//  PlantDetail.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 22.07.24.
//

import SwiftUI

struct PlantDetailAdd: View {

    // MARK: - Properties
    @Bindable var collection: PlantCollection
    @Environment(\.dismiss) private var dismiss
    @State var name: String = ""
    @State var size: Double = 100
    @State var watering: WaterRequirement = .small
    @State var image: Data? = nil
    @State var showImageButtons = false
    @State var selectedSensor: SensorIdentifier? = nil
    @State var loading: Bool = true
    @State var sensors: [SensorIdentifier] = []
    @State var fetching: Bool = true
    @State var showLogin: Bool = false
    @State var unexpectedError: BloomBuddyApiError? = nil
    @State var showSensorConfig: Bool = false
    
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
                            .onTapGesture {
                                showImageButtons = false
                            }
                        
                        PlantImage(150, "plantBg", color: .constant(.white), lineWidth: 10, data: $image, showButtons: $showImageButtons, editable: true)
                        
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
                        SensorSelector(selected: $selectedSensor, sensors: $sensors, fetching: $fetching)
                        if selectedSensor != nil, #available(iOS 18.0, *) {
                            Text("Sensor konfigurieren")
                                .bigButton {
                                    showSensorConfig = true
                                }
                        }
                        
                        if !loading {
                            WaterRequirementButtons(selected: $watering)
                        } else {
                            ProgressView().progressViewStyle(.circular)
                        }
                        
                        
                        Spacer()
                        
                        Text("Speichern")
                            .bigButton(valid: valid) {
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
            await fetchSensors()
            if edit, let plant {
                self.name = plant.name
                self.size = plant.size
                self.selectedSensor = sensors.first(where: {$0.id == plant.sensor})
                self.watering = WaterRequirement(percent: plant.waterRequirement)
                self.image = plant.image
            }
            loading = false
        }
        .sheet(isPresented: $showLogin) {
            LoginView() { dismiss in
                Task {
                    await fetchSensors()
                }
                dismiss()
            }
            .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showSensorConfig) {
            if #available(iOS 18.0, *), let sensor = selectedSensor {
                SensorConfig(sensor: sensor)
                    .interactiveDismissDisabled()
                    .padding()
            } else if #available(iOS 18.0, *){
                Text("Ein Problem ist aufgetreten")
            } else {
                Text("Nicht verfügbar auf iOS 17")
            }
        }
        .alert(item: $unexpectedError) { item in
            Alert(title: Text("Ein unerwarteter Fehler ist aufgetreten"), message: Text(item.localizedDescription))
        }
    }
    
    private func create() {
        collection.plants.append(Plant(name: name, size: size, waterRequirement: watering.percent, image: image, sensor: selectedSensor?.id))
        dismiss()
    }
    
    private func save() {
        guard let plant = collection.plants.first(where: {$0.id == plant?.id}) else { return }
        plant.name = name
        plant.waterRequirement = watering.percent
        plant.sensor = selectedSensor?.id
        plant.size = size
        plant.image = image
        
        dismiss()
    }
    
    private func fetchSensors() async {
        fetching = true
        let jwtRes = await BBAuthManager.jwt()
        switch jwtRes {
        case .success(let token):
            await sensorRequest(token)
        case .failure(let failure):
            BBController.handleUnauthorized(failure, showLogin: $showLogin, unexpectedError: $unexpectedError)
        }
        fetching = false
    }
    
    private func sensorRequest(_ token: String) async {
        let res = await BBController.request(.sensors(token), expected: [SensorIdentifier].self)
        switch res {
        case .success(let sensors):
            self.sensors = sensors
        case .failure(let failure):
            BBController.handleUnauthorized(failure, showLogin: $showLogin, unexpectedError: $unexpectedError)
        }
    }
}
