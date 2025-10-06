//
//  MenuGestureHandler.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/12/2024.
//

import SwiftUI

struct MenuGestureHandler: ViewModifier {
    @Binding var isMenuOpen: Bool
    @Binding var isSettingsOpen: Bool
    @Binding var dragOffset: CGFloat
    @Binding var settingsDragOffset: CGFloat
    
    // Configuration
    let edgeThreshold: CGFloat
    let openThreshold: CGFloat
    let closeThreshold: CGFloat
    let menuWidth: CGFloat
    let settingsWidth: CGFloat
    let includeBackgroundGestures: Bool
    
    init(
        isMenuOpen: Binding<Bool>,
        isSettingsOpen: Binding<Bool>,
        dragOffset: Binding<CGFloat>,
        settingsDragOffset: Binding<CGFloat>,
        edgeThreshold: CGFloat,
        openThreshold: CGFloat,
        closeThreshold: CGFloat,
        menuWidth: CGFloat,
        settingsWidth: CGFloat,
        includeBackgroundGestures: Bool
    ) {
        self._isMenuOpen = isMenuOpen
        self._isSettingsOpen = isSettingsOpen
        self._dragOffset = dragOffset
        self._settingsDragOffset = settingsDragOffset
        self.edgeThreshold = edgeThreshold
        self.openThreshold = openThreshold
        self.closeThreshold = closeThreshold
        self.menuWidth = menuWidth
        self.settingsWidth = settingsWidth
        self.includeBackgroundGestures = includeBackgroundGestures
    }
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { value in
                        handleDragChange(value)
                    }
                    .onEnded { value in
                        handleDragEnd(value)
                    }
            )
    }
    
    private func handleDragChange(_ value: DragGesture.Value) {
        // Edge gesture: left edge swipe for menu
        print("dragOffset is \(dragOffset)")
        if !isMenuOpen && !isSettingsOpen && value.startLocation.x < edgeThreshold && value.translation.width > 0 {
            dragOffset = min(value.translation.width, menuWidth)
        }
        // Edge gesture: right edge swipe for settings
        else if !isMenuOpen && !isSettingsOpen && value.startLocation.x > UIScreen.main.bounds.width - edgeThreshold && value.translation.width < 0 {
            settingsDragOffset = max(value.translation.width, -settingsWidth)
        }
        // Background gesture: swipe right to open menu (when includeBackgroundGestures is true)
        else if includeBackgroundGestures && !isMenuOpen && !isSettingsOpen && value.translation.width > 50 && abs(value.translation.height) < abs(value.translation.width) {
            dragOffset = min(value.translation.width - 50, menuWidth)
        }
        // Background gesture: swipe left to open settings (when includeBackgroundGestures is true)
        else if includeBackgroundGestures && !isMenuOpen && !isSettingsOpen && value.translation.width < -50 && abs(value.translation.height) < abs(value.translation.width) {
            settingsDragOffset = max(value.translation.width + 50, -settingsWidth)
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        // Open menu if dragged enough from left
        if !isMenuOpen && dragOffset > openThreshold {
            withAnimation(.easeInOut(duration: 0.3)) {
                isMenuOpen = true
            }
        }
        // Open settings if dragged enough from right
        else if !isSettingsOpen && settingsDragOffset < -openThreshold {
            withAnimation(.easeInOut(duration: 0.3)) {
                isSettingsOpen = true
            }
        }
        
        // Reset offsets
        withAnimation(.easeInOut(duration: 0.3)) {
            dragOffset = 0
            settingsDragOffset = 0
        }
    }
}

extension View {
    func menuGestures(
        isMenuOpen: Binding<Bool>,
        isSettingsOpen: Binding<Bool>,
        dragOffset: Binding<CGFloat>,
        settingsDragOffset: Binding<CGFloat>,
        edgeThreshold: CGFloat = 0,
        openThreshold: CGFloat = 20,
        closeThreshold: CGFloat = 20,
        menuWidth: CGFloat = 280,
        settingsWidth: CGFloat = 320,
        includeBackgroundGestures: Bool = false
    ) -> some View {
        self.modifier(
            MenuGestureHandler(
                isMenuOpen: isMenuOpen,
                isSettingsOpen: isSettingsOpen,
                dragOffset: dragOffset,
                settingsDragOffset: settingsDragOffset,
                edgeThreshold: edgeThreshold,
                openThreshold: openThreshold,
                closeThreshold: closeThreshold,
                menuWidth: menuWidth,
                settingsWidth: settingsWidth,
                includeBackgroundGestures: includeBackgroundGestures
            )
        )
    }
}
