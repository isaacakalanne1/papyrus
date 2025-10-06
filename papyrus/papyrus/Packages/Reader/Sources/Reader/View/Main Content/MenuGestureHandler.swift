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
    let openThreshold: CGFloat
    let closeThreshold: CGFloat
    let menuWidth: CGFloat
    let settingsWidth: CGFloat
    let isForClosing: Bool
    
    init(
        isMenuOpen: Binding<Bool>,
        isSettingsOpen: Binding<Bool>,
        dragOffset: Binding<CGFloat>,
        settingsDragOffset: Binding<CGFloat>,
        openThreshold: CGFloat,
        closeThreshold: CGFloat,
        menuWidth: CGFloat,
        settingsWidth: CGFloat,
        isForClosing: Bool
    ) {
        self._isMenuOpen = isMenuOpen
        self._isSettingsOpen = isSettingsOpen
        self._dragOffset = dragOffset
        self._settingsDragOffset = settingsDragOffset
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
        if isForClosing {
            // Handle menu closing gesture
            if isMenuOpen && value.translation.width < 0 {
                dragOffset = max(value.translation.width, -menuWidth)
            }
            // Handle settings closing gesture
            else if isSettingsOpen && value.translation.width > 0 {
                settingsDragOffset = min(value.translation.width, settingsWidth)
            }
        } else {
            // Only process horizontal swipes (ignore vertical swipes)
            if !isMenuOpen && !isSettingsOpen && abs(value.translation.height) < abs(value.translation.width) {
                // Swipe right to open menu
                if value.translation.width > 0 {
                    dragOffset = min(value.translation.width, menuWidth)
                }
                // Swipe left to open settings
                else if value.translation.width < 0 {
                    settingsDragOffset = max(value.translation.width, -settingsWidth)
                }
            }
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        if isForClosing {
            // Close menu if dragged enough to the left
            if isMenuOpen && dragOffset < -closeThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isMenuOpen = false
                }
            }
            // Close settings if dragged enough to the right
            else if isSettingsOpen && settingsDragOffset > closeThreshold {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isSettingsOpen = false
                }
            }
        } else {
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
        openThreshold: CGFloat = 50,
        closeThreshold: CGFloat = 50,
        menuWidth: CGFloat = 280,
        settingsWidth: CGFloat = 280,
        isForClosing: Bool = false
    ) -> some View {
        self.modifier(
            MenuGestureHandler(
                isMenuOpen: isMenuOpen,
                isSettingsOpen: isSettingsOpen,
                dragOffset: dragOffset,
                settingsDragOffset: settingsDragOffset,
                openThreshold: openThreshold,
                closeThreshold: closeThreshold,
                menuWidth: menuWidth,
                settingsWidth: settingsWidth,
                isForClosing: isForClosing
            )
        )
    }
}
