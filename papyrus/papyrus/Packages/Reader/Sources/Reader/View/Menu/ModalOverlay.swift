//
//  ModalOverlay.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

struct ModalOverlay: View {
    let isPresented: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        if isPresented {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onDismiss()
                    }
                }
        }
    }
}