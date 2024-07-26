//
//  CameraVM.swift
//  BloomBuddy
//
//  Created by Mia Koring on 26.07.24.
//

import Foundation
import CoreImage
import Observation

@Observable
class CameraVM {
    var currentFrame: CGImage?
    private let cameraManager = CameraManager()
    
    init() { 
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                currentFrame = image
            }
        }
    }
}
