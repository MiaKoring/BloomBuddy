//
//  SensorManager.swift
//  BloomBuddy
//
//  Created by Mia Koring on 21.08.24.
//

import Foundation

@Observable
class SensorManager: NSObject {
    var sensordata: [Sensor]?
    
    func fetch() async -> Result<[Sensor], BloomBuddyApiError> {
        let response = await BBAuthManager.jwt()
        var token = ""
        switch response {
        case .success(let success):
            token = success
        case .failure(let failure):
            return.failure(failure)
        }
        
        let res = await BloomBuddyController.request(.allSensorData(token), expected: [Sensor].self)
        
        switch res {
        case .success(let success):
            sensordata = success
        case .failure:
            break
        }
        return res
    }
}
