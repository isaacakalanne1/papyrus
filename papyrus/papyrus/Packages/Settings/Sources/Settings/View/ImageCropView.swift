import SwiftUI
import UIKit

// MARK: - UIKit gesture layer

/// Transparent overlay that uses UIKit recognizers so pinch + pan fire simultaneously.
private struct CropGestureLayer: UIViewRepresentable {
    /// Called continuously while any gesture is active.
    /// scaleSinceStart: multiplier relative to the moment gestures began (1.0 = no change yet).
    /// offsetSinceStart: translation delta in points since gestures began.
    var onChanged: (CGFloat, CGSize) -> Void
    /// Called once when the last active gesture ends.
    var onEnded: (CGFloat, CGSize) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onChanged: onChanged, onEnded: onEnded)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let pinch = UIPinchGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePinch(_:))
        )
        pinch.delegate = context.coordinator

        let pan = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan(_:))
        )
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 2
        pan.delegate = context.coordinator

        view.addGestureRecognizer(pinch)
        view.addGestureRecognizer(pan)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Keep closures current without recreating the view.
        context.coordinator.onChanged = onChanged
        context.coordinator.onEnded = onEnded
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChanged: (CGFloat, CGSize) -> Void
        var onEnded: (CGFloat, CGSize) -> Void

        private var pinchActive = false
        private var panActive   = false

        // Both accumulate from the moment each gesture began and are reported together.
        private var currentScale:  CGFloat = 1.0
        private var currentOffset: CGSize  = .zero

        init(onChanged: @escaping (CGFloat, CGSize) -> Void,
             onEnded:   @escaping (CGFloat, CGSize) -> Void) {
            self.onChanged = onChanged
            self.onEnded   = onEnded
        }

        // Allow pinch and pan to fire at the same time.
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
        ) -> Bool { true }

        @objc func handlePinch(_ r: UIPinchGestureRecognizer) {
            switch r.state {
            case .began:
                pinchActive = true
            case .changed:
                // r.scale is relative to where the pinch started — use directly.
                currentScale = r.scale
                onChanged(currentScale, currentOffset)
            case .ended, .cancelled, .failed:
                pinchActive = false
                if !panActive { commitAndReset() }
            default: break
            }
        }

        @objc func handlePan(_ r: UIPanGestureRecognizer) {
            let t = r.translation(in: r.view)
            switch r.state {
            case .began:
                panActive = true
            case .changed:
                currentOffset = CGSize(width: t.x, height: t.y)
                onChanged(currentScale, currentOffset)
            case .ended, .cancelled, .failed:
                panActive = false
                if !pinchActive { commitAndReset() }
            default: break
            }
        }

        private func commitAndReset() {
            onEnded(currentScale, currentOffset)
            currentScale  = 1.0
            currentOffset = .zero
        }
    }
}

// MARK: - Crop view

struct ImageCropView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    let onConfirm: (Data) -> Void

    // Committed state (updated only on gesture end).
    @State private var scale:  CGFloat = 1.0
    @State private var offset: CGSize  = .zero

    // Live gesture deltas (reset to identity after each gesture group ends).
    @State private var gestureScale:  CGFloat = 1.0
    @State private var gestureOffset: CGSize  = .zero

    @State private var viewSize: CGSize = .zero

    // MARK: Geometry helpers

    private func cropSize(in viewSize: CGSize) -> CGSize {
        guard viewSize != .zero else { return viewSize }
        let screenAR = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        let hIfFullWidth = viewSize.width / screenAR
        if hIfFullWidth <= viewSize.height {
            return CGSize(width: viewSize.width, height: hIfFullWidth)
        } else {
            return CGSize(width: viewSize.height * screenAR, height: viewSize.height)
        }
    }

    private func minimumScale(in viewSize: CGSize) -> CGFloat {
        guard viewSize != .zero else { return 1.0 }
        let crop     = cropSize(in: viewSize)
        let fitScale = min(viewSize.width  / image.size.width,
                          viewSize.height / image.size.height)
        let sW = crop.width  / (image.size.width  * fitScale)
        let sH = crop.height / (image.size.height * fitScale)
        return max(sW, sH, 1.0)
    }

    private func clampedOffset(_ proposed: CGSize, scale: CGFloat, in viewSize: CGSize) -> CGSize {
        guard viewSize != .zero else { return proposed }
        let crop       = cropSize(in: viewSize)
        let fitScale   = min(viewSize.width  / image.size.width,
                            viewSize.height / image.size.height)
        let displayedW = image.size.width  * fitScale * scale
        let displayedH = image.size.height * fitScale * scale
        let maxX = max(0, (displayedW - crop.width)  / 2)
        let maxY = max(0, (displayedH - crop.height) / 2)
        return CGSize(
            width:  min(maxX,  max(-maxX,  proposed.width)),
            height: min(maxY, max(-maxY, proposed.height))
        )
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let size = geometry.size
                let crop = cropSize(in: size)
                let dimX = (size.width  - crop.width)  / 2
                let dimY = (size.height - crop.height) / 2

                // Resolved live display values.
                let displayScale = scale * gestureScale
                let displayOffset = clampedOffset(
                    CGSize(
                        width:  offset.width  + gestureOffset.width,
                        height: offset.height + gestureOffset.height
                    ),
                    scale: displayScale,
                    in: size
                )

                ZStack {
                    Color.black.ignoresSafeArea()

                    // Image — hit testing disabled; the gesture layer handles touches.
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(displayScale)
                        .offset(x: displayOffset.width, y: displayOffset.height)
                        .allowsHitTesting(false)

                    // Dim areas outside the crop frame.
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

                    // UIKit gesture layer — on top so it receives all touches.
                    CropGestureLayer(
                        onChanged: { scaleDelta, offsetDelta in
                            gestureScale  = scaleDelta
                            gestureOffset = offsetDelta
                        },
                        onEnded: { finalScale, finalOffset in
                            let newScale = max(minimumScale(in: size), scale * finalScale)
                            let newOffset = clampedOffset(
                                CGSize(
                                    width:  offset.width  + finalOffset.width,
                                    height: offset.height + finalOffset.height
                                ),
                                scale: newScale,
                                in: size
                            )
                            scale  = newScale
                            offset = newOffset
                            gestureScale  = 1.0
                            gestureOffset = .zero
                        }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .onAppear {
                    viewSize = size
                    scale    = minimumScale(in: size)
                    offset   = .zero
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

    // MARK: Crop extraction

    private func cropToDeviceAspectRatio() -> Data? {
        guard viewSize != .zero else { return image.jpegData(compressionQuality: 0.8) }

        let crop      = cropSize(in: viewSize)
        let fitScale  = min(viewSize.width  / image.size.width,
                           viewSize.height / image.size.height)
        let dispScale = fitScale * scale
        let dispW     = image.size.width  * dispScale
        let dispH     = image.size.height * dispScale

        let imgOriginX  = (viewSize.width  - dispW) / 2 + offset.width
        let imgOriginY  = (viewSize.height - dispH) / 2 + offset.height
        let cropOriginX = (viewSize.width  - crop.width)  / 2
        let cropOriginY = (viewSize.height - crop.height) / 2

        let cropInImgX = (cropOriginX - imgOriginX) / dispScale
        let cropInImgY = (cropOriginY - imgOriginY) / dispScale
        let cropInImgW = crop.width  / dispScale
        let cropInImgH = crop.height / dispScale

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
