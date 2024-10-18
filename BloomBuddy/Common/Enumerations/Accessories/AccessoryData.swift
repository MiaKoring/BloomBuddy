//
//  AccessoryData.swift
//  BloomBuddy
//
//  Created by Mia Koring on 15.10.24.
//

import CoreBluetooth
import AccessorySetupKit

enum AccessoryData: CaseIterable {
    case sensorProV1
}

extension AccessoryData {
    var serviceUUID: CBUUID {
        switch self {
        case .sensorProV1: CBUUID(string: "87B8170E-5ABF-4B23-A3C6-983BF8E964A9")
        }
    }
    
    @available(iOS 18.0, *) var descriptor: ASDiscoveryDescriptor {
        switch self {
        case .sensorProV1:
            let descriptor = ASDiscoveryDescriptor()
            descriptor.bluetoothServiceUUID = self.serviceUUID
            return descriptor
        }
    }
    
    @available(iOS 18.0, *) var displayItem: ASPickerDisplayItem {
        switch self {
        case .sensorProV1:
            return ASPickerDisplayItem(
                name: "Sensor Pro 1",
                productImage: UIImage(named: "sensorPreassembledV1") ?? UIImage(systemName: "sensor")!, //TODO: Add real rendering of sensor
                descriptor: self.descriptor
            )
        }
    }
    
    @available(iOS 18.0, *) static var allDisplayItems: [ASPickerDisplayItem] {
        AccessoryData.allCases.map(\.displayItem)
    }
}
