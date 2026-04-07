//
//  BackgroundImageContextTests.swift
//  Settings
//

import Testing
import Foundation
import PapyrusStyleKit

class BackgroundImageContextTests {

    // MARK: - displayName Tests

    @Test
    func home_displayName() {
        #expect(BackgroundImageContext.home.displayName == "Home")
    }

    @Test
    func story_displayName() {
        #expect(BackgroundImageContext.story.displayName == "Story")
    }

    @Test
    func interactiveStory_displayName() {
        #expect(BackgroundImageContext.interactiveStory.displayName == "Interactive Story")
    }

    // MARK: - CaseIterable Tests

    @Test
    func allCases_containsAllContexts() {
        let allCases = BackgroundImageContext.allCases
        #expect(allCases.contains(.home))
        #expect(allCases.contains(.story))
        #expect(allCases.contains(.interactiveStory))
        #expect(allCases.count == 3)
    }

    // MARK: - Codable Round-trip Tests

    @Test
    func codable_roundTrip_home() throws {
        let original = BackgroundImageContext.home
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(BackgroundImageContext.self, from: data)
        #expect(decoded == original)
    }

    @Test
    func codable_roundTrip_story() throws {
        let original = BackgroundImageContext.story
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(BackgroundImageContext.self, from: data)
        #expect(decoded == original)
    }

    @Test
    func codable_roundTrip_interactiveStory() throws {
        let original = BackgroundImageContext.interactiveStory
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(BackgroundImageContext.self, from: data)
        #expect(decoded == original)
    }

    @Test
    func codable_roundTrip_set() throws {
        let original: Set<BackgroundImageContext> = [.home, .interactiveStory]
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Set<BackgroundImageContext>.self, from: data)
        #expect(decoded == original)
    }

    @Test
    func rawValue_home() {
        #expect(BackgroundImageContext.home.rawValue == "home")
    }

    @Test
    func rawValue_story() {
        #expect(BackgroundImageContext.story.rawValue == "story")
    }

    @Test
    func rawValue_interactiveStory() {
        #expect(BackgroundImageContext.interactiveStory.rawValue == "interactiveStory")
    }

    // MARK: - Hashable Tests

    @Test
    func hashable_canBeUsedInSet() {
        var contexts: Set<BackgroundImageContext> = []
        contexts.insert(.home)
        contexts.insert(.home)
        #expect(contexts.count == 1)
        contexts.insert(.story)
        #expect(contexts.count == 2)
    }
}
