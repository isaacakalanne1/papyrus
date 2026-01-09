//
//  MenuGestureHandler.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/12/2024.
//

import SwiftUI

struct MenuGestureHandler: ViewModifier {
    @EnvironmentObject var store: ReaderStore
    
    // Configuration
    let openThreshold: CGFloat
    let closeThreshold: CGFloat
    let isForClosing: Bool
    let isEnabled: Bool
    
    init(
        openThreshold: CGFloat,
        closeThreshold: CGFloat,
        isForClosing: Bool,
        isEnabled: Bool
    ) {
        self.openThreshold = openThreshold
        self.closeThreshold = closeThreshold
        self.isForClosing = isForClosing
        self.isEnabled = isEnabled
    }
    
    func body(content: Content) -> some View {
        if isEnabled {
            content
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged { value in
                            handleDragChange(value)
                        }
                        .onEnded { value in
                            handleDragEnd(value)
                        }
                )
        } else {
            content
        }
    }
    
    private func handleDragChange(_ value: DragGesture.Value) {
        store.dispatch(.setDragOffset(value.translation.width))
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        let dragOffset = value.translation.width
        let menuStatus = store.state.menuStatus
        
        if isForClosing {
            // Close menu if dragged enough to the left
            if menuStatus == .storyOpen && dragOffset < -closeThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.dispatch(.setMenuStatus(.closed))
                }
            }
            // Close settings if dragged enough to the right
            else if menuStatus == .settingsOpen && dragOffset > closeThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.dispatch(.setMenuStatus(.closed))
                }
            }
        } else {
            // Open menu if dragged enough from left
            if menuStatus == .closed && dragOffset > openThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.dispatch(.setMenuStatus(.storyOpen))
                }
            }
            // Open settings if dragged enough from right
            else if menuStatus == .closed && dragOffset < -openThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.dispatch(.setMenuStatus(.settingsOpen))
                }
            }
        }
        
        // Reset offsets always
        withAnimation(.easeInOut(duration: 0.3)) {
            store.dispatch(.setDragOffset(0))
        }
    }
}

extension View {
    func menuGestures(
        openThreshold: CGFloat = 50,
        closeThreshold: CGFloat = 50,
        isForClosing: Bool = false,
        isEnabled: Bool = true
    ) -> some View {
        self.modifier(
            MenuGestureHandler(
                openThreshold: openThreshold,
                closeThreshold: closeThreshold,
                isForClosing: isForClosing,
                isEnabled: isEnabled
            )
        )
    }
}
