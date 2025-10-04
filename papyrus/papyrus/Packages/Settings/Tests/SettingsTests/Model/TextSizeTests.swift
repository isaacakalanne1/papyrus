//
//  TextSizeTests.swift
//  Settings
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import SwiftUI
@testable import Settings

class TextSizeTests {
    
    // MARK: - Raw Value Tests
    
    @Test(arguments: [
        (TextSize.small, "small"),
        (TextSize.medium, "medium"),
        (TextSize.large, "large"),
        (TextSize.extraLarge, "extraLarge")
    ])
    func textSize_rawValue(textSize: TextSize, expectedRawValue: String) {
        #expect(textSize.rawValue == expectedRawValue)
    }
    
    // MARK: - Font Size Tests
    
    @Test(arguments: [
        (TextSize.small, 16.0),
        (TextSize.medium, 18.0),
        (TextSize.large, 20.0),
        (TextSize.extraLarge, 24.0)
    ])
    func textSize_fontSize(textSize: TextSize, expectedFontSize: CGFloat) {
        #expect(textSize.fontSize == expectedFontSize)
    }
    
    // MARK: - Icon Scale Tests
    
    @Test(arguments: [
        (TextSize.small, 0.8),
        (TextSize.medium, 1.0),
        (TextSize.large, 1.2),
        (TextSize.extraLarge, 1.4)
    ])
    func textSize_iconScale(textSize: TextSize, expectedIconScale: CGFloat) {
        #expect(textSize.iconScale == expectedIconScale)
    }
    
    // MARK: - Initialization from Raw Value Tests
    
    @Test(arguments: [
        ("small", TextSize.small),
        ("medium", TextSize.medium),
        ("large", TextSize.large),
        ("extraLarge", TextSize.extraLarge)
    ])
    func textSize_initFromRawValue(rawValue: String, expectedTextSize: TextSize) {
        let textSize = TextSize(rawValue: rawValue)
        #expect(textSize == expectedTextSize)
    }
    
    @Test(arguments: [
        "tiny",
        "huge",
        "invalid",
        "",
        "SMALL"
    ])
    func textSize_initFromInvalidRawValue(invalidRawValue: String) {
        let textSize = TextSize(rawValue: invalidRawValue)
        #expect(textSize == nil)
    }
    
    // MARK: - CaseIterable Conformance Tests
    
    @Test
    func textSize_allCases() {
        let allCases = TextSize.allCases
        let expectedCases: [TextSize] = [.small, .medium, .large, .extraLarge]
        
        #expect(allCases.count == 4)
        #expect(allCases == expectedCases)
    }
    
    @Test
    func textSize_allCasesOrder() {
        let allCases = TextSize.allCases
        
        // Verify the order matches expected progression
        #expect(allCases[0] == .small)
        #expect(allCases[1] == .medium)
        #expect(allCases[2] == .large)
        #expect(allCases[3] == .extraLarge)
    }
    
    // MARK: - Codable Conformance Tests
    
    @Test(arguments: [
        TextSize.small,
        TextSize.medium,
        TextSize.large,
        TextSize.extraLarge
    ])
    func textSize_encodeDecode(textSize: TextSize) throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(textSize)
        let decodedTextSize = try decoder.decode(TextSize.self, from: encodedData)
        
        #expect(decodedTextSize == textSize)
    }
    
    @Test
    func textSize_encodeAsString() throws {
        let encoder = JSONEncoder()
        let textSize = TextSize.medium
        
        let encodedData = try encoder.encode(textSize)
        let jsonString = String(data: encodedData, encoding: .utf8)
        
        #expect(jsonString == "\"medium\"")
    }
    
    @Test
    func textSize_decodeFromInvalidJSON() {
        let decoder = JSONDecoder()
        let invalidJSON = "\"invalidSize\"".data(using: .utf8)!
        
        #expect(throws: DecodingError.self) {
            try decoder.decode(TextSize.self, from: invalidJSON)
        }
    }
    
    // MARK: - Equality Tests
    
    @Test
    func textSize_equality() {
        #expect(TextSize.small == TextSize.small)
        #expect(TextSize.medium == TextSize.medium)
        #expect(TextSize.large == TextSize.large)
        #expect(TextSize.extraLarge == TextSize.extraLarge)
        
        #expect(TextSize.small != TextSize.medium)
        #expect(TextSize.medium != TextSize.large)
        #expect(TextSize.large != TextSize.extraLarge)
    }
    
    // MARK: - Font Size Progression Tests
    
    @Test
    func textSize_fontSizeProgression() {
        let allCases = TextSize.allCases
        
        // Verify font sizes increase in order
        for i in 0..<(allCases.count - 1) {
            let currentSize = allCases[i]
            let nextSize = allCases[i + 1]
            #expect(currentSize.fontSize < nextSize.fontSize)
        }
    }
    
    @Test
    func textSize_fontSizeMinimumValues() {
        // Ensure all font sizes are reasonable
        for textSize in TextSize.allCases {
            #expect(textSize.fontSize > 0)
            #expect(textSize.fontSize >= 10) // Minimum readable size
            #expect(textSize.fontSize <= 30) // Maximum reasonable size
        }
    }
    
    // MARK: - Icon Scale Progression Tests
    
    @Test
    func textSize_iconScaleProgression() {
        let allCases = TextSize.allCases
        
        // Verify icon scales increase in order
        for i in 0..<(allCases.count - 1) {
            let currentSize = allCases[i]
            let nextSize = allCases[i + 1]
            #expect(currentSize.iconScale < nextSize.iconScale)
        }
    }
    
    @Test
    func textSize_iconScaleReasonableValues() {
        // Ensure all icon scales are reasonable
        for textSize in TextSize.allCases {
            #expect(textSize.iconScale > 0)
            #expect(textSize.iconScale >= 0.5) // Minimum visible scale
            #expect(textSize.iconScale <= 2.0) // Maximum reasonable scale
        }
    }
    
    @Test
    func textSize_mediumIsBaseline() {
        // Medium should be the baseline (1.0) for icon scale
        #expect(TextSize.medium.iconScale == 1.0)
    }
    
    // MARK: - Integration Tests
    
    @Test(arguments: [
        TextSize.small,
        TextSize.medium,
        TextSize.large,
        TextSize.extraLarge
    ])
    func textSize_allProperties(textSize: TextSize) {
        // Test that all properties are accessible and non-zero
        #expect(textSize.rawValue.isEmpty == false)
        #expect(textSize.fontSize > 0)
        #expect(textSize.iconScale > 0)
        
        // Test consistency between properties
        // Larger text sizes should generally have larger font sizes and icon scales
        if textSize != .small {
            let smallerCase = TextSize.allCases[TextSize.allCases.firstIndex(of: textSize)! - 1]
            #expect(textSize.fontSize >= smallerCase.fontSize)
            #expect(textSize.iconScale >= smallerCase.iconScale)
        }
    }
    
    // MARK: - Sendable Conformance Test
    
    @Test
    func textSize_sendableConformance() async {
        // Test that TextSize can be safely passed across concurrency boundaries
        let textSize = TextSize.medium
        
        let result = await withCheckedContinuation { continuation in
            Task {
                continuation.resume(returning: textSize)
            }
        }
        
        #expect(result == textSize)
    }
}