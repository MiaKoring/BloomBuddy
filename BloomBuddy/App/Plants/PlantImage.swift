//
//  PlantImage.swift
//  BloomBuddy
//
//  Created by Simon Zwicker on 23.07.24.
//

import SwiftUI
import PhotosUI
import SwiftyCrop

struct PlantImage: View {

    // MARK: - Properties
    let size: CGFloat
    let imageName: String
    @Binding var color: Color
    let lineWidth: CGFloat
    @Binding var data: Data?
    @Binding var showButtons: Bool
    let editable: Bool
    @State private var item: PhotosPickerItem?
    @State var showImageLoadError: Bool = false
    @State var image: UIImage? = nil
    @State var showEdit = false
    @State var showCamera = false
    @State private var cameraModel = CameraVM()
    
    let configuration = SwiftyCropConfiguration(rotateImage: false)

    init(_ size: CGFloat, _ imageName: String, color: Binding<Color>, lineWidth: CGFloat = 8, data: Binding<Data?> = .constant(nil), showButtons: Binding<Bool>, editable: Bool = false) {
        self.size = size
        self.imageName = imageName
        self._color = color
        self.lineWidth = lineWidth
        self._data = data
        self._showButtons = showButtons
        self.editable = editable
    }

    var body: some View {
        ZStack {
            VStack {
                if let data, let uiImage = UIImage(data: data) {
                    if editable {
                        Image(uiImage: uiImage)
                            .editPlantImage(size: size, color: color, lineWidth: lineWidth)
                    } else {
                        Image(uiImage: uiImage)
                            .plantImage()
                    }
                } else {
                    if editable {
                        Image(imageName)
                            .editPlantImage(size: size, color: color, lineWidth: lineWidth)
                    } else {
                        Image(imageName)
                            .plantImage()
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if !showButtons && editable {
                    Image(systemName: "photo.circle.fill")
                        .symbolRenderingMode(.palette)
                        .font(.Regular.large)
                        .foregroundStyle(
                            .black.opacity(0.8),
                            .white
                        )
                        .offset(x: 2, y: 2)
                }
            }
            if showButtons {
                VStack {
                    PhotosPicker(selection: $item, matching: .images) {
                        Image(systemName: "photo.stack")
                            .font(.system(size: 30))
                    }
                    Button {
                        image = nil
                        showCamera = true
                    } label: {
                        Image(systemName: "camera")
                            .font(.system(size: 30))
                    }
                    .frame(maxHeight: .infinity)
                }
                .padding(20)
                .frame(width: size, height: size)
                .clipShape(.circle)
                .background(
                    Circle()
                        .fill(color.gradient)
                        .frame(width: size + lineWidth, height: size + lineWidth)
                )
            }
        }
        .if(editable) { view in
            view
                .button {
                    withAnimation {
                        showButtons.toggle()
                    }
                }
        }
        .onChange(of: item) {
            getData()
        }
        .alert("Fehler beim Laden des Bildes", isPresented: $showImageLoadError) {
            Button("OK", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showEdit, onDismiss: {
            withAnimation {
                showButtons = false
            }
        }) {
            if let image {
                SwiftyCropView(
                    imageToCrop: image,
                    maskShape: .circle,
                    configuration: configuration
                ) { croppedImage in
                    data = croppedImage?.pngData()
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(image: $cameraModel.currentFrame) { captured in
                let uiImage = UIImage(cgImage: captured, scale: 1.0, orientation: .right)
                image = uiImage
                showEdit = true
            }
        }
    }
    
    private func getData () {
        Task {
            guard let res = try? await item?.loadTransferable(type: Data.self) else {
                showImageLoadError = true
                print("failed")
                return
            }
            guard let uiImage = UIImage(data: res) else { return }
            image = uiImage
            showEdit = true
        }
    }
}
