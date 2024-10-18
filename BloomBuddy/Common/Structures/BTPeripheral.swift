//
//  BTPeripheral.swift
//  BloomBuddy
//
//  Created by Mia Koring on 18.10.24.
//

import CoreBluetooth

struct BTPeripheral {
    let value: CBPeripheral
    let advertisementData: [String: Any]
}
