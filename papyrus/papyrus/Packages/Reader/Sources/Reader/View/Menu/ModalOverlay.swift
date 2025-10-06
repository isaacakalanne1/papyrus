//
//  ModalOverlay.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

struct ModalOverlay: View {
    let isPresented: Bool
    let opacity: Double
    let onDismiss: () -> Void
    let onDrag: (DragGesture.Value) -> Void
    let onDragEnded: (DragGesture.Value) -> Void
    
    var body: some View {
        if isPresented || opacity > 0 {
            Color.black.opacity(opacity)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onDismiss()
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged(onDrag)
                        .onEnded(onDragEnded)
                )
                .allowsHitTesting(opacity > 0.01)
        }
    }
}