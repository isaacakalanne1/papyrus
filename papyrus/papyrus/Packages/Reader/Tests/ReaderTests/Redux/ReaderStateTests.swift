//
//  ReaderStateTests.swift
//  ReaderTests
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import TextGeneration
import Settings
@testable import Reader

@Suite("ReaderState Tests")
struct ReaderStateTests {
    
    @Test("Initial state should have default values")
    func initialState() {
        // Given & When
        let state = ReaderState()
        
        // Then
        #expect(state.mainCharacter == "")
        #expect(state.setting == "")
        #expect(state.loadedStories.isEmpty)
        #expect(state.story == nil)
        #expect(state.sequelStory == nil)
        #expect(!state.isLoading)
        #expect(state.loadingStep == .idle)
        #expect(!state.showStoryForm)
        #expect(!state.showSubscriptionSheet)
    }
    
    @Test("Custom initialization should set all properties")
    func customInitialization() {
        // Given
        let stories = [Story.arrange]
        let story = Story.arrange
        let settingsState = SettingsState()
        
        // When
        let state = ReaderState(
            mainCharacter: "Test Character",
            setting: "Test Setting",
            loadedStories: stories,
            story: story,
            sequelStory: story,
            isLoading: true,
            loadingStep: .creatingPlotOutline,
            settingsState: settingsState,
            showStoryForm: true,
            showSubscriptionSheet: true
        )
        
        // Then
        #expect(state.mainCharacter == "Test Character")
        #expect(state.setting == "Test Setting")
        #expect(state.loadedStories.count == 1)
        #expect(state.story != nil)
        #expect(state.sequelStory != nil)
        #expect(state.isLoading)
        #expect(state.loadingStep == .creatingPlotOutline)
        #expect(state.showStoryForm)
        #expect(state.showSubscriptionSheet)
    }
    
    @Test("Can create chapter without story")
    func canCreateChapterWithoutStory() {
        // Given
        let state = ReaderState()
        
        // When & Then
        #expect(state.canCreateChapter)
    }
    
    @Test("Can create chapter with subscription")
    func canCreateChapterWithSubscription() {
        // Given
        var settingsState = SettingsState()
        settingsState.isSubscribed = true
        let story = Story.arrange(chapters: [
            Chapter.arrange,
            Chapter.arrange,
            Chapter.arrange // 3 chapters
        ])
        let state = ReaderState(
            story: story,
            settingsState: settingsState
        )
        
        // When & Then
        #expect(state.canCreateChapter)
    }
    
    @Test("Can create chapter without subscription under limit")
    func canCreateChapterWithoutSubscriptionUnderLimit() {
        // Given
        var settingsState = SettingsState()
        settingsState.isSubscribed = false
        let story = Story.arrange(chapters: [Chapter.arrange]) // 1 chapter
        let state = ReaderState(
            story: story,
            settingsState: settingsState
        )
        
        // When & Then
        #expect(state.canCreateChapter)
    }
    
    @Test("Cannot create chapter without subscription over limit")
    func cannotCreateChapterWithoutSubscriptionOverLimit() {
        // Given
        var settingsState = SettingsState()
        settingsState.isSubscribed = false
        let story = Story.arrange(chapters: [
            Chapter.arrange,
            Chapter.arrange // 2 chapters (at limit)
        ])
        let state = ReaderState(
            story: story,
            settingsState: settingsState
        )
        
        // When & Then
        #expect(!state.canCreateChapter)
    }
    
    @Test("Content state should be welcome for empty state")
    func contentStateWelcome() {
        // Given
        let state = ReaderState()
        
        // When & Then
        switch state.contentState {
        case .welcome:
            // Expected
            break
        case .story:
            Issue.record("Expected welcome state")
        }
    }
    
    @Test("Content state should be welcome for story with empty chapters")
    func contentStateWelcomeWithEmptyStory() {
        // Given
        let emptyStory = Story.arrange(chapters: [])
        let state = ReaderState(story: emptyStory)
        
        // When & Then
        switch state.contentState {
        case .welcome:
            // Expected
            break
        case .story:
            Issue.record("Expected welcome state for story with no chapters")
        }
    }
    
    @Test("Content state should be welcome for invalid chapter index")
    func contentStateWelcomeWithInvalidChapterIndex() {
        // Given
        let story = Story.arrange(
            chapterIndex: 1,
            chapters: [Chapter.arrange] // Index out of bounds
        )
        let state = ReaderState(story: story)
        
        // When & Then
        switch state.contentState {
        case .welcome:
            // Expected
            break
        case .story:
            Issue.record("Expected welcome state for invalid chapter index")
        }
    }
    
    @Test("Content state should be story for valid story")
    func contentStateStory() {
        // Given
        let story = Story.arrange(
            chapterIndex: 0,
            chapters: [Chapter.arrange, Chapter.arrange]
        )
        let state = ReaderState(story: story)
        
        // When & Then
        switch state.contentState {
        case .welcome:
            Issue.record("Expected story state")
        case .story(let extractedStory):
            #expect(extractedStory.id == story.id)
            #expect(extractedStory.chapters.count == 2)
            #expect(extractedStory.chapterIndex == 0)
        }
    }
    
    @Test("Loading step enum should be equatable", 
          arguments: [LoadingStep.idle, .creatingPlotOutline, .creatingChapterBreakdown, 
                     .analyzingStructure, .preparingNarrative, .writingChapter])
    func loadingStepEnum(step: LoadingStep) {
        // Test that all loading steps are equatable
        #expect(step == step)
    }
    
    @Test("Different loading steps should not be equal")
    func loadingStepInequality() {
        #expect(LoadingStep.idle != LoadingStep.creatingPlotOutline)
        #expect(LoadingStep.writingChapter != LoadingStep.idle)
    }
    
    @Test("State equality should work correctly")
    func stateEquality() {
        // Given
        let state1 = ReaderState(mainCharacter: "Test", setting: "Setting")
        let state2 = ReaderState(mainCharacter: "Test", setting: "Setting")
        let state3 = ReaderState(mainCharacter: "Different", setting: "Setting")
        
        // When & Then
        #expect(state1 == state2)
        #expect(state1 != state3)
    }
}
