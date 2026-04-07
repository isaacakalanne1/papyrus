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

    // The largest rectangle with the device's screen aspect ratio that fits within the crop view.
    private func cropSize(in viewSize: CGSize) -> CGSize {
        guard viewSize != .zero else { return viewSize }
        let screenAR = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        let heightIfFullWidth = viewSize.width / screenAR
        if heightIfFullWidth <= viewSize.height {
            return CGSize(width: viewSize.width, height: heightIfFullWidth)
        } else {
            return CGSize(width: viewSize.height * screenAR, height: viewSize.height)
        }
    }

    // Minimum scale so the image covers the crop frame completely.
    private func minimumScale(in viewSize: CGSize) -> CGFloat {
        guard viewSize != .zero else { return 1.0 }
        let crop = cropSize(in: viewSize)
        let fitScale = min(viewSize.width / image.size.width, viewSize.height / image.size.height)
        let scaleForWidth  = crop.width  / (image.size.width  * fitScale)
        let scaleForHeight = crop.height / (image.size.height * fitScale)
        return max(scaleForWidth, scaleForHeight, 1.0)
    }

    // Clamp offset so the image never exposes background inside the crop frame.
    private func clampedOffset(_ proposed: CGSize, scale: CGFloat, in viewSize: CGSize) -> CGSize {
        guard viewSize != .zero else { return proposed }
        let crop = cropSize(in: viewSize)
        let fitScale   = min(viewSize.width / image.size.width, viewSize.height / image.size.height)
        let displayedW = image.size.width  * fitScale * scale
        let displayedH = image.size.height * fitScale * scale

        let maxOffsetX = max(0, (displayedW - crop.width)  / 2)
        let maxOffsetY = max(0, (displayedH - crop.height) / 2)

        return CGSize(
            width:  min(maxOffsetX,  max(-maxOffsetX,  proposed.width)),
            height: min(maxOffsetY, max(-maxOffsetY, proposed.height))
        )
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let size = geometry.size
                let crop = cropSize(in: size)

                ZStack {
                    Color.black.ignoresSafeArea()

                    // Image — unclamped during gestures for responsive feel; clamped on release.
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale * magnifyBy)
                        .offset(
                            x: offset.width  + dragOffset.width,
                            y: offset.height + dragOffset.height
                        )
                        .simultaneousGesture(
                            MagnificationGesture()
                                .updating($magnifyBy) { value, state, _ in state = value }
                                .onEnded { value in
                                    let newScale = max(minimumScale(in: size), scale * value)
                                    scale  = newScale
                                    offset = clampedOffset(offset, scale: newScale, in: size)
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in state = value.translation }
                                .onEnded { value in
                                    let proposed = CGSize(
                                        width:  offset.width  + value.translation.width,
                                        height: offset.height + value.translation.height
                                    )
                                    offset = clampedOffset(proposed, scale: scale, in: size)
                                }
                        )

                    // Dim the areas outside the crop frame.
                    let dimX = (size.width  - crop.width)  / 2
                    let dimY = (size.height - crop.height) / 2

                    if dimX > 0 {
                        HStack(spacing: 0) {
                            Color.black.opacity(0.55).frame(width: dimX)
                            Color.clear.frame(width: crop.width)
                            Color.black.opacity(0.55).frame(width: dimX)
                        }
                        .allowsHitTesting(false)
                    }
                    if dimY > 0 {
                        VStack(spacing: 0) {
                            Color.black.opacity(0.55).frame(height: dimY)
                            Color.clear.frame(height: crop.height)
                            Color.black.opacity(0.55).frame(height: dimY)
                        }
                        .allowsHitTesting(false)
                    }

                    // Crop frame border.
                    Rectangle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
                        .frame(width: crop.width, height: crop.height)
                        .allowsHitTesting(false)
                }
                .onAppear {
                    viewSize = size
                    scale  = minimumScale(in: size)
                    offset = .zero
                }
                .onChange(of: geometry.size) { _, newSize in
                    viewSize = newSize
                    scale  = max(minimumScale(in: newSize), scale)
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
                        if let data = cropToDeviceAspectRatio() { onConfirm(data) }
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
        guard viewSize != .zero else { return image.jpegData(compressionQuality: 0.8) }

        let crop      = cropSize(in: viewSize)
        let fitScale  = min(viewSize.width / image.size.width, viewSize.height / image.size.height)
        let dispScale = fitScale * scale
        let dispW     = image.size.width  * dispScale
        let dispH     = image.size.height * dispScale

        // Top-left of the image in the view's coordinate space.
        let imgOriginX = (viewSize.width  - dispW) / 2 + offset.width
        let imgOriginY = (viewSize.height - dispH) / 2 + offset.height

        // Top-left of the crop frame in the view's coordinate space.
        let cropOriginX = (viewSize.width  - crop.width)  / 2
        let cropOriginY = (viewSize.height - crop.height) / 2

        // Map crop frame into image-pixel coordinates.
        let cropInImgX = (cropOriginX - imgOriginX) / dispScale
        let cropInImgY = (cropOriginY - imgOriginY) / dispScale
        let cropInImgW = crop.width  / dispScale
        let cropInImgH = crop.height / dispScale

        // Render at retina resolution.
        let outputSize = CGSize(
            width:  crop.width  * UIScreen.main.scale,
            height: crop.height * UIScreen.main.scale
        )
        let drawScale = outputSize.width / cropInImgW

        let renderer = UIGraphicsImageRenderer(size: outputSize)
        let cropped = renderer.image { _ in
            image.draw(in: CGRect(
                x: -cropInImgX * drawScale,
                y: -cropInImgY * drawScale,
                width:  image.size.width  * drawScale,
                height: image.size.height * drawScale
            ))
        }
        return cropped.jpegData(compressionQuality: 0.8)
    }
}
