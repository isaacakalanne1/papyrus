import SwiftUI
import UIKit

struct ImageCropView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    let onConfirm: (Data) -> Void

    @State private var scale: CGFloat = 1.0
    @GestureState private var magnifyBy: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var viewSize: CGSize = .zero

    private var targetAspectRatio: CGFloat {
        UIScreen.main.bounds.width / UIScreen.main.bounds.height
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let cropWidth = geometry.size.width
                let cropHeight = cropWidth / targetAspectRatio
                let cropVerticalPadding = max(0, (geometry.size.height - cropHeight) / 2)

                ZStack {
                    Color.black.ignoresSafeArea()

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale * magnifyBy)
                        .offset(
                            x: offset.width + dragOffset.width,
                            y: offset.height + dragOffset.height
                        )
                        .simultaneousGesture(
                            MagnificationGesture()
                                .updating($magnifyBy) { value, state, _ in state = value }
                                .onEnded { value in
                                    scale = max(1.0, scale * value)
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in state = value.translation }
                                .onEnded { value in
                                    offset.width += value.translation.width
                                    offset.height += value.translation.height
                                }
                        )

                    // Dim areas above and below the crop frame
                    VStack(spacing: 0) {
                        Color.black.opacity(0.5)
                            .frame(height: cropVerticalPadding)
                        Color.clear
                            .frame(width: cropWidth, height: cropHeight)
                        Color.black.opacity(0.5)
                            .frame(height: cropVerticalPadding)
                    }
                    .allowsHitTesting(false)

                    // Crop frame border
                    Rectangle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
                        .frame(width: cropWidth, height: cropHeight)
                        .allowsHitTesting(false)
                }
                .onAppear {
                    viewSize = geometry.size
                }
                .onChange(of: geometry.size) { _, newSize in
                    viewSize = newSize
                }
            }
            .navigationTitle("Crop Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let data = cropToDeviceAspectRatio() {
                            onConfirm(data)
                        }
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private func cropToDeviceAspectRatio() -> Data? {
        guard viewSize != .zero else {
            return image.jpegData(compressionQuality: 0.8)
        }

        let cropWidth = viewSize.width
        let cropHeight = cropWidth / targetAspectRatio

        // How the image is displayed (scaledToFit) before user gestures
        let fitScale = min(viewSize.width / image.size.width, viewSize.height / image.size.height)
        let displayScale = fitScale * scale
        let displayedWidth = image.size.width * displayScale
        let displayedHeight = image.size.height * displayScale

        // Top-left of displayed image in view coordinates
        let imageOriginX = (viewSize.width - displayedWidth) / 2 + offset.width
        let imageOriginY = (viewSize.height - displayedHeight) / 2 + offset.height

        // Top-left of crop frame in view coordinates
        let cropFrameOriginY = (viewSize.height - cropHeight) / 2

        // Crop region in image-space coordinates
        let cropInImageX = (0 - imageOriginX) / displayScale
        let cropInImageY = (cropFrameOriginY - imageOriginY) / displayScale
        let cropInImageW = cropWidth / displayScale
        let cropInImageH = cropHeight / displayScale

        // Render output at retina resolution
        let outputSize = CGSize(
            width: cropWidth * UIScreen.main.scale,
            height: cropHeight * UIScreen.main.scale
        )
        let drawScale = outputSize.width / cropInImageW

        let renderer = UIGraphicsImageRenderer(size: outputSize)
        let croppedImage = renderer.image { _ in
            let drawRect = CGRect(
                x: -cropInImageX * drawScale,
                y: -cropInImageY * drawScale,
                width: image.size.width * drawScale,
                height: image.size.height * drawScale
            )
            image.draw(in: drawRect)
        }

        return croppedImage.jpegData(compressionQuality: 0.8)
    }
}
