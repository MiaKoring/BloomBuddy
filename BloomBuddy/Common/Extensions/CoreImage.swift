//
//  CoreImage.swift
//  BloomBuddy
//
//  Created by Mia Koring on 26.07.24.
//

import CoreImage

extension CIImage {
    
    var cgImage: CGImage? {
        let ciContext = CIContext()
        
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {
            return nil
        }
        
        return cgImage
    }
    
}
