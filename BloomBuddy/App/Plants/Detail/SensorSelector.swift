//
//  SensorSelector.swift
//  BloomBuddy
//
//  Created by Mia Koring on 24.08.24.
//

import Foundation
import SwiftUI

struct SensorSelector: View {
    @Binding var selected: SensorIdentifier?
    @Binding var sensors: [SensorIdentifier]
    @State var showLogin: Bool = false
    @State var unexpectedError: BloomBuddyApiError? = nil
    @Binding var fetching: Bool
    @State var showSensorDetailAdd: Bool = false
    
    var body: some View {
        VStack {
            if !sensors.isEmpty {
                BBSensorPickerButton(placeholder: "Sensor", options: sensors, selected: $selected) {
                    Task {
                        await fetchSensors()
                    }
                }
            } else if fetching {
                ProgressView().progressViewStyle(.circular)
            } else {
                VStack {
                    Text("Sensor hinzufügen")
                        .bigButton {
                            showSensorDetailAdd = true
                        }
                    Text("Nur erforderlich wenn sie einen Bodenfeuchte Sensor von uns gekauft haben und nutzen möchten")
                        .font(.caption)
                }
                
            }
        }
        .task {
            await fetchSensors()
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
        .sheet(isPresented: $showSensorDetailAdd, onDismiss: refreshSensors) {
            SensorDetailAdd()
                .padding(20)
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.visible)
        }
        .alert(item: $unexpectedError) { item in
            Alert(title: Text("Ein unerwarteter Fehler ist aufgetreten"), message: Text(item.localizedDescription))
        }
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
        case .success(let res):
            sensors = res
        case .failure(let failure):
            BBController.handleUnauthorized(failure, showLogin: $showLogin, unexpectedError: $unexpectedError)
        }
    }
    
    private func refreshSensors() {
        Task {
            await fetchSensors()
        }
    }
    
}
