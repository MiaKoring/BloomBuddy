//
//  CameraView.swift
//  BloomBuddy
//
//  Created by Mia Koring on 26.07.24.
//

import SwiftUI

struct CameraView: View {
    
    @Binding var image: CGImage?
    let onCapture: (CGImage) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let image = image {
            Image(decorative: image, scale: 1, orientation: .right)
                .resizable()
                .scaledToFill()
                .overlay(alignment: .bottom) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 50)
                        Circle()
                            .stroke(lineWidth: 5)
                            .fill(.white)
                            .frame(width: 60)
                    }
                    .button {
                        onCapture(image)
                        dismiss()
                    }
                    .padding(.bottom, 50)
                }
                .overlay(alignment: .bottom) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Abbrechen")
                    }
                    .offset(x: -100)
                    .padding(.bottom, 70)
                    .foregroundStyle(.white)
                }
                .ignoresSafeArea()
        } else {
            ContentUnavailableView("Kein Kamera Feed", systemImage: "xmark.circle.fill")
            Button {
                dismiss()
            } label: {
                Text("Zurück")
            }
        }
        
    }
    
}
