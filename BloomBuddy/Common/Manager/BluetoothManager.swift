//
//  BluetoothManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.10.24.
//
import CoreBluetooth
import Combine
import AccessorySetupKit

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var writtenValue: Data?
    @Published var discoveredPeripherals: [BTPeripheral] = []
    @Published var failedToConnect: AnyEquatableError?

    private var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var targetCharacteristic: CBCharacteristic?
    var service: CBService?
    
    var peripheralDidDiscoverService: ((CBService) -> Void)?
    var peripheralDidDiscoverCharacteristic: ((CBCharacteristic) -> Void)?
    var periperalDidUpdateValue: ((Data) -> Void)?
    var peripheralDidConnect: ((CBPeripheral) -> Void)?

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
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheralDidConnect?(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        failedToConnect = AnyEquatableError(error)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: {$0.value == peripheral}) {
            discoveredPeripherals.append(BTPeripheral(value: peripheral, advertisementData: advertisementData))
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let service = peripheral.services?.first {
            self.peripheralDidDiscoverService?(service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristic = service.characteristics?.first {
            self.peripheralDidDiscoverCharacteristic?(characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value for characteristic: \(error.localizedDescription)")
            return
        }

        guard let value = characteristic.value else {
            return
        }
        writtenValue = value
        print("Updated value for characteristic: \(String(data: value, encoding: .utf8) ?? "")")
        self.periperalDidUpdateValue?(value)
    }

    func connectToPeripheral(_ peripheral: CBPeripheral) async -> CBPeripheral {
        centralManager.connect(peripheral, options: nil)
        peripheral.delegate = self
        
        return await waitForPeripheralDidConnect(peripheral)
    }

    func writeValueWithResponse(to peripheral: CBPeripheral, serviceUUID: CBUUID, value: Data) async -> Data? {
        peripheral.discoverServices([serviceUUID])

        if let service = await waitForService(peripheral: peripheral) {
            print("Service gefunden: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)

            if let characteristic = await waitForCharacteristic(peripheral: peripheral) {
                print("Characteristic gefunden: \(characteristic.uuid)")

                peripheral.writeValue(value, for: characteristic, type: .withResponse)
                peripheral.readValue(for: characteristic)
                return await waitForUpdatedValue(peripheral: peripheral)
            } else {
                print("Keine beschreibbare Characteristic gefunden")
            }
        } else {
            print("Kein Service gefunden")
        }
        return nil
    }

    func waitForService(peripheral: CBPeripheral) async -> CBService? {
        return await withCheckedContinuation { continuation in
            self.peripheralDidDiscoverService = { service in
                continuation.resume(returning: service)
            }
        }
    }

    func waitForCharacteristic(peripheral: CBPeripheral) async -> CBCharacteristic? {
        return await withCheckedContinuation { continuation in
            self.peripheralDidDiscoverCharacteristic = { characteristic in
                continuation.resume(returning: characteristic)
            }
        }
    }
    
    func waitForUpdatedValue(peripheral: CBPeripheral) async -> Data? {
        return await withCheckedContinuation { continuation in
            self.periperalDidUpdateValue = { value in
                continuation.resume(returning: value)
            }
        }
    }
    
    func waitForPeripheralDidConnect(_ peripheral: CBPeripheral) async -> CBPeripheral {
        return await withCheckedContinuation { continuation in
            self.peripheralDidConnect = { value in
                continuation.resume(returning: value)
            }
        }
    }
}

