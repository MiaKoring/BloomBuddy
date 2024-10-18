//
//  SensorConfigView.swift
//  BloomBuddy
//
//  Created by Mia Koring on 15.10.24.
//

import SwiftUI
import AccessorySetupKit
import CoreBluetooth

@available(iOS 18.0, *)
struct SensorConfig: View {
    let sensor: SensorIdentifier
    @State private var session = ASAccessorySession()
    @StateObject var btManager: BluetoothManager = BluetoothManager()
    @State var pickedAccessory: ASAccessory?
    @State var connectedPeripheral: CBPeripheral?
    @State var connectedAccessoryServiceUUID: CBUUID?
    @State var page: Int = 0 //TODO: Change to enum
    @State var showFailedConnectionAlert: Bool = false
    
    var body: some View {
        Image("plantBg")
            .resizable()
        Text("Drücke den grünen Button am Gehäuse des Sensor-Controllers, danach tippe unten auf fortfahren. Stelle sicher, dass nur ein Sensor zur Zeit Bluetooth an hat (bei aktiviertem bluetooth leuchtet die LED im Gehäuse statisch blau).")
            .task {
                session.activate(on: DispatchQueue.main, eventHandler: handleSessionEvent)
            }
        Text("Fortfahren")
            .bigButton {
                Task {
                    await showASKSheet()
                }
            }
            .onChange(of: btManager.failedToConnect) { showFailedConnectionAlert = true }
            .alert("Ein Verbindungsfehler ist aufgetreten.", isPresented: $showFailedConnectionAlert) {
                Button {
                    Task {
                        await showASKSheet()
                    }
                } label: {
                    Text("Erneut versuchen")
                }
            } message: {
                Text("\(btManager.failedToConnect?.error?.localizedDescription ?? "Keine Fehlerinformationen verfügbar")")
            }
    }
    
    func showASKSheet() async {
        await removeAllAccessoryConnections()
        session.showPicker(for: AccessoryData.allDisplayItems) { error in
            if let error {
                print("Error: \(error)")
            }
        }
    }
    
    func handleSessionEvent(_ event: ASAccessoryEvent) {
        switch event.eventType {
        case .activated:
            print("Session is activated")
            print(session.accessories)
        case .accessoryAdded:
            print("Accessory Connected")
            guard let accessory = event.accessory else {
                print("Accessory is nil")
                return
            }
            self.pickedAccessory = accessory
        case .pickerDidDismiss:
            guard let accessory = pickedAccessory else {
                return
            }
            self.pickedAccessory = nil
            Task {
                self.connectedPeripheral = await self.handleAccessoryAdded(accessory)
            }
        default:
            print("Recieved event type: \(event.description)")
        }
    }
    
    func handleAccessoryAdded(_ accessory: ASAccessory) async -> CBPeripheral? {
        guard let btIdentifier = accessory.bluetoothIdentifier else {
            print("accessory has no bluetooth identifier")
            return nil
        }
        guard let wrapper = btManager.discoveredPeripherals.first(where: {$0.value.identifier == btIdentifier}) else {
            print("Not found")
            return nil
        }
        let peripheral = await btManager.connectToPeripheral(wrapper.value)
        connectedAccessoryServiceUUID = accessory.descriptor.bluetoothServiceUUID
        return peripheral
    }
    
    func removeAllAccessoryConnections() async {
        for accessory in session.accessories {
            do {
                try await session.removeAccessory(accessory)
            } catch {
                print("Error removing accessory: \(error)")
            }
        }
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        Text("")
            .sheet(isPresented: .constant(true)) {
                SensorConfig(sensor: SensorIdentifier(id: UUID(), name: "lol"))
                    .interactiveDismissDisabled()
                    .padding()
            }
    } else {
        Text("Unavailable on iOS 17.")
    }
}
