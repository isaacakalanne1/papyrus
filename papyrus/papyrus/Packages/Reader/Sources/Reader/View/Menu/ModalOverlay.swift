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
    
    var body: some View {
        if isPresented || opacity > 0 {
            Color.black.opacity(opacity)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onDismiss()
                    }
                }
                .allowsHitTesting(opacity > 0.01)
        }
    }
}
