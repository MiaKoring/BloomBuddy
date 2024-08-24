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
    @State var sensors: [SensorIdentifier] = []
    @State var showLogin: Bool = false
    @State var unexpectedError: BloomBuddyApiError? = nil
    @State var fetching: Bool = true
    
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
                //TODO: Sensor creation button
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
        case .success(let sensors):
            self.sensors = sensors
        case .failure(let failure):
            BBController.handleUnauthorized(failure, showLogin: $showLogin, unexpectedError: $unexpectedError)
        }
    }
}
