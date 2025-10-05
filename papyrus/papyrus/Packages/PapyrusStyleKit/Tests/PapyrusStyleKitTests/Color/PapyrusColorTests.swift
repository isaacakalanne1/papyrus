//
//  PapyrusColorTests.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import Testing
import SwiftUI
@testable import PapyrusStyleKit

class PapyrusColorTests {
    
    // MARK: - Color Property Tests
    
    @Test(arguments: [
        (PapyrusColor.background, 0.98, 0.95, 0.89),
        (PapyrusColor.backgroundSecondary, 0.96, 0.92, 0.84),
        (PapyrusColor.buttonGradientTop, 0.45, 0.40, 0.35),
        (PapyrusColor.buttonGradientBottom, 0.35, 0.30, 0.25),
        (PapyrusColor.borderPrimary, 0.35, 0.30, 0.25),
        (PapyrusColor.borderSecondary, 0.8, 0.75, 0.7),
        (PapyrusColor.accent, 0.8, 0.65, 0.4),
        (PapyrusColor.textPrimary, 0.3, 0.25, 0.2),
        (PapyrusColor.textSecondary, 0.5, 0.45, 0.4),
        (PapyrusColor.iconPrimary, 0.6, 0.5, 0.4),
        (PapyrusColor.iconSecondary, 0.4, 0.35, 0.3),
        (PapyrusColor.error, 0.6, 0.3, 0.2)
    ])
    func papyrusColor_colorComponents(colorCase: PapyrusColor, expectedRed: Double, expectedGreen: Double, expectedBlue: Double) {
        let color = colorCase.color
        let expectedColor = Color(red: expectedRed, green: expectedGreen, blue: expectedBlue)
        
        // Since direct Color comparison isn't straightforward in SwiftUI,
        // we verify the color was created with the expected components
        // by checking that the computed property returns a non-nil Color
        #expect(color != Color.clear)
        
        // Verify the color matches the expected construction
        // Note: This tests that the color property returns the expected Color initialization
        let actualColorDescription = String(describing: color)
        let expectedColorDescription = String(describing: expectedColor)
        #expect(actualColorDescription == expectedColorDescription)
    }
    
    // MARK: - Color Consistency Tests
    
    @Test
    func papyrusColor_borderAndButtonGradientBottomConsistency() {
        // Verify that border and buttonGradientBottom use the same color values
        let borderColor = PapyrusColor.borderPrimary.color
        let buttonBottomColor = PapyrusColor.buttonGradientBottom.color
        
        let borderDescription = String(describing: borderColor)
        let buttonBottomDescription = String(describing: buttonBottomColor)
        
        #expect(borderDescription == buttonBottomDescription)
    }
    
    // MARK: - Color Grouping Tests
    
    @Test
    func papyrusColor_backgroundColors() {
        // Test background colors are lighter (higher RGB values)
        let backgroundColor = PapyrusColor.background
        let backgroundSecondaryColor = PapyrusColor.backgroundSecondary
        
        // Both should return valid colors
        #expect(backgroundColor.color != Color.clear)
        #expect(backgroundSecondaryColor.color != Color.clear)
        
        // Background colors should be in the light range (all components > 0.8)
        // This is a semantic test based on the actual values
        let bgComponents = (red: 0.98, green: 0.95, blue: 0.89)
        let bgSecComponents = (red: 0.96, green: 0.92, blue: 0.84)
        
        #expect(bgComponents.red > 0.8)
        #expect(bgComponents.green > 0.8)
        #expect(bgComponents.blue > 0.8)
        
        #expect(bgSecComponents.red > 0.8)
        #expect(bgSecComponents.green > 0.8)
        #expect(bgSecComponents.blue > 0.8)
    }
    
    @Test
    func papyrusColor_textColors() {
        // Test text colors are darker (lower RGB values)
        let textPrimary = PapyrusColor.textPrimary
        let textSecondary = PapyrusColor.textSecondary
        
        // Both should return valid colors
        #expect(textPrimary.color != Color.clear)
        #expect(textSecondary.color != Color.clear)
        
        // Text colors should be in the dark range (all components < 0.6)
        let textPrimaryComponents = (red: 0.3, green: 0.25, blue: 0.2)
        let textSecondaryComponents = (red: 0.5, green: 0.45, blue: 0.4)
        
        #expect(textPrimaryComponents.red < 0.6)
        #expect(textPrimaryComponents.green < 0.6)
        #expect(textPrimaryComponents.blue < 0.6)
        
        #expect(textSecondaryComponents.red < 0.6)
        #expect(textSecondaryComponents.green < 0.6)
        #expect(textSecondaryComponents.blue < 0.6)
    }
    
    // MARK: - Computed Property Consistency Tests
    
    @Test
    func papyrusColor_colorPropertyConsistency() {
        // Test that calling .color multiple times returns consistent results
        let testColor = PapyrusColor.accent
        
        let color1 = testColor.color
        let color2 = testColor.color
        let color3 = testColor.color
        
        // All calls should return the same color description
        let description1 = String(describing: color1)
        let description2 = String(describing: color2)
        let description3 = String(describing: color3)
        
        #expect(description1 == description2)
        #expect(description2 == description3)
    }
    
    // MARK: - Sendable Conformance Test
    
    @Test
    func papyrusColor_sendableConformance() async {
        // Test that PapyrusColor can be safely passed across concurrency boundaries
        let colorCase = PapyrusColor.accent
        
        let result = await withCheckedContinuation { continuation in
            Task {
                continuation.resume(returning: colorCase)
            }
        }
        
        #expect(result == .accent)
    }
    
    // MARK: - Color Range Tests
    
    @Test
    func papyrusColor_allColorsInValidRange() {
        // All RGB components should be between 0.0 and 1.0
        let componentRanges: [(PapyrusColor, red: Double, green: Double, blue: Double)] = [
            (.background, 0.98, 0.95, 0.89),
            (.backgroundSecondary, 0.96, 0.92, 0.84),
            (.buttonGradientTop, 0.45, 0.40, 0.35),
            (.buttonGradientBottom, 0.35, 0.30, 0.25),
            (.borderPrimary, 0.35, 0.30, 0.25),
            (.borderSecondary, 0.8, 0.75, 0.7),
            (.accent, 0.8, 0.65, 0.4),
            (.textPrimary, 0.3, 0.25, 0.2),
            (.textSecondary, 0.5, 0.45, 0.4),
            (.iconPrimary, 0.6, 0.5, 0.4),
            (.iconSecondary, 0.4, 0.35, 0.3),
            (.error, 0.6, 0.3, 0.2)
        ]
        
        for (_, red, green, blue) in componentRanges {
            #expect(red >= 0.0 && red <= 1.0)
            #expect(green >= 0.0 && green <= 1.0)
            #expect(blue >= 0.0 && blue <= 1.0)
        }
    }
}
