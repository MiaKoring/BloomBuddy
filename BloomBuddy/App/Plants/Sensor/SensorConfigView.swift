//
//  SensorConfigView.swift
//  BloomBuddy
//
//  Created by Mia Koring on 15.10.24.
//

import SwiftUI
import AccessorySetupKit
import CoreBluetooth
import Combine

@available(iOS 18.0, *)
struct SensorConfig: View {
    @State private var session = ASAccessorySession()
    @StateObject var btManager: BluetoothManager = BluetoothManager()
    @State var pickedAccessory: ASAccessory?
    
    var body: some View {
        Text("Drücke den grünen Button am Gehäuse des Sensor-Controllers, danach tippe unten auf fortfahren. Stelle sicher, dass nur ein Sensor zur Zeit Bluetooth an hat (bei aktiviertem bluetooth leuchtet die LED im Gehäuse statisch blau).")
            .task {
                session.activate(on: DispatchQueue.main, eventHandler: handleSessionEvent)
                
                
            }
        Text("Fortfahren")
            .bigButton {
                let allPeripheralUUIDs = btManager.discoveredPeripherals.map(\.identifier.uuidString)
                let allAccessoryUUIDs = AccessoryData.allCases.map(\.serviceUUID.uuidString)
                let combined = Set(allPeripheralUUIDs + allAccessoryUUIDs)
                //if combined.count == allPeripheralUUIDs
                session.showPicker(for: AccessoryData.allDisplayItems) { error in
                    if let error {
                        print("Error: \(error)")
                    } else {
                        
                    }
                }
            }
        Text("mit existierendem Sensor verbinden")
            .bigButton {
                let accessory = session.accessories.first!
                handleAccessoryAdded(accessory)
            }
        Text("Ping senden")
            .bigButton {
                let accessory = session.accessories.first!
                let peripheral = handleAccessoryAdded(accessory)!
                Task {
                    try? await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
                   await btManager.writeValue(to: peripheral, value: "ping".data(using: .utf8)!)
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
            self.handleAccessoryAdded(accessory)
        default:
            print("Recieved event type: \(event.description)")
        }
    }
    
    func handleAccessoryAdded(_ accessory: ASAccessory) -> CBPeripheral? {
        guard let btIdentifier = accessory.bluetoothIdentifier else {
            print("accessory has no bluetooth identifier")
            return nil
        }
        guard let peripheral = btManager.discoveredPeripherals.first(where: {$0.identifier == btIdentifier}) else {
            print("Not found")
            return nil
        }
        btManager.connectToPeripheral(peripheral)
        return peripheral
    }
    
    
}


class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [CBPeripheral]()

    private var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var targetCharacteristic: CBCharacteristic?
    var service: CBService?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBluetoothEnabled = true
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            isBluetoothEnabled = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        service = peripheral.services?.first
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        var characteristicsArray = [CBCharacteristic]()
        
        for characteristic in service.characteristics ?? [] {
            characteristicsArray.append(characteristic)
            
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
                print("subscribed")
            }
        }
        
        targetCharacteristic = characteristicsArray.first
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }

        if let value = characteristic.value {
            // Hier kannst du mit dem neuen Wert arbeiten
            print("Updated value for characteristic: \(String(data: value, encoding: .utf8))")
        }
    }
    
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        peripheral.delegate = self
    }
    
    func writeValue(to peripheral: CBPeripheral, value: Data) async {
        peripheral.discoverServices([AccessoryData.sensorProV1.serviceUUID])
        do {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        } catch {
            print("Error sleeping")
        }
        guard let service = service else {
            print("keine services gefunden")
            return
        }
        print("service gefunden")
        peripheral.discoverCharacteristics(nil, for: service)
        do {
            try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        } catch {
            print("Error sleeping")
        }
        guard let characteristic = targetCharacteristic else {
            print("Keine beschreibbare Characteristic gefunden")
            return
        }
        print("characteristic gefunden")

        // Hier wird der Wert in die Characteristic geschrieben
        peripheral.writeValue(value, for: characteristic, type: .withResponse)
        peripheral.readValue(for: characteristic)
    }
}
