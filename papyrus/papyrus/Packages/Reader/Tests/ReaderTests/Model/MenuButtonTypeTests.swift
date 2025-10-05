//
//  MenuButtonTypeTests.swift
//  ReaderTests
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import SwiftUI
import PapyrusStyleKit
@testable import Reader

@Suite("MenuButtonType Tests")
struct MenuButtonTypeTests {
    
    @Test("Menu button icons should be correct")
    func menuButtonIcon() {
        #expect(MenuButtonType.menu.icon == "text.alignleft")
        #expect(MenuButtonType.settings.icon == "gearshape")
        #expect(MenuButtonType.previous.icon == "chevron.left")
        #expect(MenuButtonType.next.icon == "chevron.right")
        #expect(MenuButtonType.close.icon == "xmark.circle.fill")
    }
    
    @Test("Menu button sizes should be correct")
    func menuButtonSize() {
        #expect(MenuButtonType.menu.size == 20)
        #expect(MenuButtonType.settings.size == 20)
        #expect(MenuButtonType.previous.size == 16)
        #expect(MenuButtonType.next.size == 16)
        #expect(MenuButtonType.close.size == 24)
    }
    
    @Test("Menu button frame sizes should be correct")
    func menuButtonFrameSize() {
        #expect(MenuButtonType.menu.frameSize == 44)
        #expect(MenuButtonType.settings.frameSize == 44)
        #expect(MenuButtonType.previous.frameSize == 32)
        #expect(MenuButtonType.next.frameSize == 32)
        #expect(MenuButtonType.close.frameSize == 24)
    }
    
    @Test("Menu button weights should be correct")
    func menuButtonWeight() {
        #expect(MenuButtonType.menu.weight == .regular)
        #expect(MenuButtonType.settings.weight == .regular)
        #expect(MenuButtonType.previous.weight == .medium)
        #expect(MenuButtonType.next.weight == .medium)
        #expect(MenuButtonType.close.weight == .regular)
    }
    
    @Test("Menu button colors should be correct")
    func menuButtonColor() {
        let expectedCloseColor = PapyrusColor.iconPrimary.color
        let expectedDefaultColor = PapyrusColor.iconSecondary.color
        
        #expect(MenuButtonType.close.color == expectedCloseColor)
        #expect(MenuButtonType.menu.color == expectedDefaultColor)
        #expect(MenuButtonType.settings.color == expectedDefaultColor)
        #expect(MenuButtonType.previous.color == expectedDefaultColor)
        #expect(MenuButtonType.next.color == expectedDefaultColor)
    }
    
    @Test("All menu button types should have valid properties", 
          arguments: [MenuButtonType.menu, .settings, .previous, .next, .close])
    func allMenuButtonTypes(type: MenuButtonType) {
        #expect(!type.icon.isEmpty, "Icon should not be empty for \(type)")
        #expect(type.size > 0, "Size should be greater than 0 for \(type)")
        #expect(type.frameSize > 0, "Frame size should be greater than 0 for \(type)")
    }
    
    @Test("Menu button type consistency")
    func menuButtonTypeConsistency() {
        // Test that menu and settings buttons have the same size and frame size
        #expect(MenuButtonType.menu.size == MenuButtonType.settings.size)
        #expect(MenuButtonType.menu.frameSize == MenuButtonType.settings.frameSize)
        #expect(MenuButtonType.menu.weight == MenuButtonType.settings.weight)
        #expect(MenuButtonType.menu.color == MenuButtonType.settings.color)
        
        // Test that previous and next buttons have the same size and frame size
        #expect(MenuButtonType.previous.size == MenuButtonType.next.size)
        #expect(MenuButtonType.previous.frameSize == MenuButtonType.next.frameSize)
        #expect(MenuButtonType.previous.weight == MenuButtonType.next.weight)
        #expect(MenuButtonType.previous.color == MenuButtonType.next.color)
    }
}
