//
//  MenuGestureHandler.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/12/2024.
//

import SwiftUI

struct MenuGestureHandler: ViewModifier {
    @Binding var menuStatus: ReaderView.MenuStatus
    @Binding var dragOffset: CGFloat
    
    // Configuration
    let openThreshold: CGFloat
    let closeThreshold: CGFloat
    let menuWidth: CGFloat
    let settingsWidth: CGFloat
    let isForClosing: Bool
    
    init(
        menuStatus: Binding<ReaderView.MenuStatus>,
        dragOffset: Binding<CGFloat>,
        openThreshold: CGFloat,
        closeThreshold: CGFloat,
        menuWidth: CGFloat,
        settingsWidth: CGFloat,
        isForClosing: Bool
    ) {
        self._menuStatus = menuStatus
        self._dragOffset = dragOffset
        self.openThreshold = openThreshold
        self.closeThreshold = closeThreshold
        self.menuWidth = menuWidth
        self.settingsWidth = settingsWidth
        self.isForClosing = isForClosing
    }
    
    func body(content: Content) -> some View {
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
    }
    
    private func handleDragChange(_ value: DragGesture.Value) {
        dragOffset = value.translation.width
        print("offset is \(dragOffset)")
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        if isForClosing {
            // Close menu if dragged enough to the left
            if menuStatus == .storyOpen && dragOffset < -closeThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    menuStatus = .closed
                }
            }
            // Close settings if dragged enough to the right
            else if menuStatus == .settingsOpen && dragOffset > closeThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    menuStatus = .closed
                }
            }
        } else {
            // Open menu if dragged enough from left
            if menuStatus == .closed && dragOffset > openThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    menuStatus = .storyOpen
                }
            }
            // Open settings if dragged enough from right
            else if menuStatus == .closed && dragOffset < -openThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    menuStatus = .settingsOpen
                }
            }
        }
        
        // Reset offsets
        withAnimation(.easeInOut(duration: 0.3)) {
            dragOffset = 0
        }
    }
}

extension View {
    func menuGestures(
        menuStatus: Binding<ReaderView.MenuStatus>,
        dragOffset: Binding<CGFloat>,
        openThreshold: CGFloat = 50,
        closeThreshold: CGFloat = 50,
        menuWidth: CGFloat = 280,
        settingsWidth: CGFloat = 280,
        isForClosing: Bool = false
    ) -> some View {
        self.modifier(
            MenuGestureHandler(
                menuStatus: menuStatus,
                dragOffset: dragOffset,
                openThreshold: openThreshold,
                closeThreshold: closeThreshold,
                menuWidth: menuWidth,
                settingsWidth: settingsWidth,
                isForClosing: isForClosing
            )
        )
    }
}
