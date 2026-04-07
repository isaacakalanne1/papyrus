import SwiftUI
import UIKit

struct ImageCropView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    let onConfirm: (Data) -> Void

    @State private var scale: CGFloat = 1.0
    @GestureState private var magnifyBy: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var liveDragOffset: CGSize = .zero
    @State private var viewSize: CGSize = .zero

    private var targetAspectRatio: CGFloat {
        let bounds = UIScreen.main.bounds
        return bounds.width / bounds.height
    }

    private func cropHeight(in size: CGSize) -> CGFloat {
        size.width / targetAspectRatio
    }

    private func minimumScale(in size: CGSize) -> CGFloat {
        guard size != .zero else { return 1.0 }
        let fitScale = min(size.width / image.size.width, size.height / image.size.height)
        let scaleForWidth = size.width / (image.size.width * fitScale)
        let scaleForHeight = cropHeight(in: size) / (image.size.height * fitScale)
        return max(scaleForWidth, scaleForHeight, 1.0)
    }

    private func clampedOffset(_ proposed: CGSize, scale: CGFloat, in size: CGSize) -> CGSize {
        guard size != .zero else { return proposed }
        let fitScale = min(size.width / image.size.width, size.height / image.size.height)
        let displayedW = image.size.width * fitScale * scale
        let displayedH = image.size.height * fitScale * scale
        let cropH = cropHeight(in: size)

        let maxOffsetX = max(0, (displayedW - size.width) / 2)
        let maxOffsetY = max(0, (displayedH - cropH) / 2)

        return CGSize(
            width: min(maxOffsetX, max(-maxOffsetX, proposed.width)),
            height: min(maxOffsetY, max(-maxOffsetY, proposed.height))
        )
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let size = geometry.size
                let cropH = cropHeight(in: size)
                let cropVerticalPadding = max(0, (size.height - cropH) / 2)
                let currentScale = scale * magnifyBy
                let liveOffset = clampedOffset(
                    CGSize(
                        width: offset.width + liveDragOffset.width,
                        height: offset.height + liveDragOffset.height
                    ),
                    scale: currentScale,
                    in: size
                )

                ZStack {
                    Color.black.ignoresSafeArea()

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(currentScale)
                        .offset(x: liveOffset.width, y: liveOffset.height)
                        .simultaneousGesture(
                            MagnificationGesture()
                                .updating($magnifyBy) { value, state, _ in state = value }
                                .onEnded { value in
                                    let newScale = max(minimumScale(in: size), scale * value)
                                    scale = newScale
                                    offset = clampedOffset(offset, scale: newScale, in: size)
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .updating($liveDragOffset) { value, state, _ in state = value.translation }
                                .onEnded { value in
                                    let proposed = CGSize(
                                        width: offset.width + value.translation.width,
                                        height: offset.height + value.translation.height
                                    )
                                    offset = clampedOffset(proposed, scale: scale, in: size)
                                }
                        )

                    // Dim areas outside crop frame
                    VStack(spacing: 0) {
                        Color.black.opacity(0.5)
                            .frame(height: cropVerticalPadding)
                        Color.clear
                            .frame(width: size.width, height: cropH)
                        Color.black.opacity(0.5)
                            .frame(height: cropVerticalPadding)
                    }
                    .allowsHitTesting(false)

                    // Crop frame border
                    Rectangle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
                        .frame(width: size.width, height: cropH)
                        .allowsHitTesting(false)
                }
                .onAppear {
                    viewSize = size
                    scale = minimumScale(in: size)
                }
                .onChange(of: geometry.size) { _, newSize in
                    viewSize = newSize
                    scale = max(minimumScale(in: newSize), scale)
                    offset = clampedOffset(offset, scale: scale, in: newSize)
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

        let cropW = viewSize.width
        let cropH = cropHeight(in: viewSize)
        let fitScale = min(viewSize.width / image.size.width, viewSize.height / image.size.height)
        let displayScale = fitScale * scale
        let displayedW = image.size.width * displayScale
        let displayedH = image.size.height * displayScale

        let imageOriginX = (viewSize.width - displayedW) / 2 + offset.width
        let imageOriginY = (viewSize.height - displayedH) / 2 + offset.height
        let cropFrameOriginY = (viewSize.height - cropH) / 2

        let cropInImageX = (0 - imageOriginX) / displayScale
        let cropInImageY = (cropFrameOriginY - imageOriginY) / displayScale
        let cropInImageW = cropW / displayScale
        let cropInImageH = cropH / displayScale

        let outputSize = CGSize(
            width: cropW * UIScreen.main.scale,
            height: cropH * UIScreen.main.scale
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
