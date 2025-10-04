//
//  ContentStateTests.swift
//  ReaderTests
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import Testing
import TextGeneration
@testable import Reader

@Suite("ContentState Tests")
struct ContentStateTests {
    
    @Test("Welcome state should not have story")
    func welcomeState() {
        // Given
        let welcomeState = ContentState.welcome
        
        // When & Then
        #expect(!welcomeState.hasStory)
    }
    
    @Test("Story state should have story")
    func storyState() {
        // Given
        let story = Story.arrange
        let storyState = ContentState.story(story)
        
        // When & Then
        #expect(storyState.hasStory)
    }
    
    @Test("Story state with specific story should extract correctly")
    func storyStateWithSpecificStory() {
        // Given
        let id = UUID()
        let story = Story.arrange(
            id: id,
            mainCharacter: "Test Character",
            setting: "Test Setting",
            chapterIndex: 0,
            maxNumberOfChapters: 5,
            scrollOffset: 0,
            title: "Test Story",
            chapters: [
                Chapter.arrange(content: "Test content")
            ]
        )
        let storyState = ContentState.story(story)
        
        // When & Then
        #expect(storyState.hasStory)
        
        // Test pattern matching
        switch storyState {
        case .welcome:
            Issue.record("Expected story state, got welcome")
        case .story(let extractedStory):
            #expect(extractedStory.id == id)
            #expect(extractedStory.title == "Test Story")
            #expect(extractedStory.mainCharacter == "Test Character")
        }
    }
    
    @Test("Content state equality comparison")
    func contentStateEquality() {
        // Given
        let story1 = Story.arrange
        let story2 = Story.arrange
        
        // When & Then
        #expect(ContentState.welcome.hasStory == ContentState.welcome.hasStory)
        #expect(ContentState.story(story1).hasStory == ContentState.story(story2).hasStory)
        #expect(ContentState.welcome.hasStory != ContentState.story(story1).hasStory)
    }
}
