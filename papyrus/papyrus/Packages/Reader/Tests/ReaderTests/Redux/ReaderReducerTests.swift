//
//  ReaderReducerTests.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import Foundation
import TextGeneration
import Settings
@testable import Reader

class ReaderReducerTests {
    
    // MARK: - Story Creation Tests
    
    @Test
    func createStory_noStateChange() {
        let initialState = ReaderState.arrange(
            mainCharacter: "John Doe",
            setting: "Modern City"
        )
        
        let newState = readerReducer(initialState, .createStory)
        
        var expectedState = initialState
        // No change expected as createStory is handled by middleware
        
        #expect(newState == expectedState)
    }
    
    @Test
    func beginCreateStory() {
        let initialState = ReaderState.arrange(
            mainCharacter: "John Doe",
            setting: "Modern City"
        )
        
        let newState = readerReducer(initialState, .beginCreateStory)
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.showStoryForm = false
        expectedState.loadingStep = .creatingPlotOutline
        expectedState.story = newState.story // Use the actual created story with its generated UUID
        
        #expect(newState == expectedState)
    }
    
    @Test
    func createSequel_noStateChange() {
        let originalStoryId = UUID()
        let originalStory = Story(
            id: originalStoryId,
            mainCharacter: "Original Character",
            setting: "Original Setting",
            title: "Original Story"
        )
        
        let initialState = ReaderState.arrange(
            mainCharacter: "Sequel Character",
            setting: "Sequel Setting",
            story: originalStory
        )
        
        let newState = readerReducer(initialState, .createSequel)
        
        var expectedState = initialState
        // No change expected as createSequel is handled by middleware
        
        #expect(newState == expectedState)
    }
    
    @Test
    func beginCreateSequel() {
        let originalStoryId = UUID()
        let originalStory = Story(
            id: originalStoryId,
            mainCharacter: "Original Character",
            setting: "Original Setting",
            title: "Original Story"
        )
        
        let initialState = ReaderState.arrange(
            mainCharacter: "Sequel Character",
            setting: "Sequel Setting",
            story: originalStory
        )
        
        let newState = readerReducer(initialState, .beginCreateSequel)
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.showStoryForm = false
        expectedState.loadingStep = .creatingPlotOutline
        expectedState.sequelStory = newState.sequelStory // Use the actual created sequel story with its generated UUID
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Plot and Chapter Creation Tests
    
    @Test
    func createPlotOutline() {
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.loadingStep = .creatingPlotOutline
        
        let newState = readerReducer(initialState, .createPlotOutline(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onCreatedPlotOutline() {
        let initialState = ReaderState.arrange(isLoading: false)
        
        var expectedState = initialState
        expectedState.isLoading = true
        
        let newState = readerReducer(initialState, .onCreatedPlotOutline(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func createChapterBreakdown() {
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.loadingStep = .creatingChapterBreakdown
        
        let newState = readerReducer(initialState, .createChapterBreakdown(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onCreatedChapterBreakdown() {
        let initialState = ReaderState.arrange(isLoading: false)
        
        var expectedState = initialState
        expectedState.isLoading = true
        
        let newState = readerReducer(initialState, .onCreatedChapterBreakdown(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func getStoryDetails() {
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.loadingStep = .analyzingStructure
        
        let newState = readerReducer(initialState, .getStoryDetails(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onGetStoryDetails() {
        let initialState = ReaderState.arrange(isLoading: false)
        
        var expectedState = initialState
        expectedState.isLoading = true
        
        let newState = readerReducer(initialState, .onGetStoryDetails(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func getChapterTitle() {
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.loadingStep = .preparingNarrative
        
        let newState = readerReducer(initialState, .getChapterTitle(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onGetChapterTitle() {
        let initialState = ReaderState.arrange(isLoading: false)
        
        var expectedState = initialState
        expectedState.isLoading = true
        
        let newState = readerReducer(initialState, .onGetChapterTitle(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func createChapter_noStateChange() {
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        // No change expected as createChapter is handled by middleware
        
        let newState = readerReducer(initialState, .createChapter(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func beginCreateChapter() {
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.loadingStep = .writingChapter
        
        let newState = readerReducer(initialState, .beginCreateChapter(Story()))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onCreatedChapter_withMatchingStoryId() {
        let storyId = UUID()
        let existingStory = Story(id: storyId, title: "Existing Story")
        let updatedStory = Story(id: storyId, title: "Updated Story")
        
        let initialState = ReaderState.arrange(
            story: existingStory,
            isLoading: true,
            loadingStep: .writingChapter
        )
        
        var expectedState = initialState
        expectedState.story = updatedStory
        expectedState.isLoading = false
        expectedState.loadingStep = .idle
        expectedState.loadedStories = [updatedStory]
        
        let newState = readerReducer(initialState, .onCreatedChapter(updatedStory))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onCreatedChapter_withDifferentStoryId() {
        let currentStoryId = UUID()
        let differentStoryId = UUID()
        let currentStory = Story(id: currentStoryId, title: "Current Story")
        let updatedStory = Story(id: differentStoryId, title: "Different Story")
        
        let initialState = ReaderState.arrange(
            story: currentStory,
            isLoading: true,
            loadingStep: .writingChapter
        )
        
        var expectedState = initialState
        expectedState.story = currentStory // Story remains unchanged
        expectedState.isLoading = false
        expectedState.loadingStep = .idle
        expectedState.loadedStories = [updatedStory]
        
        let newState = readerReducer(initialState, .onCreatedChapter(updatedStory))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onCreatedChapter_updatesExistingInLoadedStories() {
        let storyId = UUID()
        let existingStory = Story(id: storyId, title: "Old Title")
        let updatedStory = Story(id: storyId, title: "New Title")
        
        let initialState = ReaderState.arrange(
            loadedStories: [existingStory],
            isLoading: true
        )
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.loadingStep = .idle
        expectedState.loadedStories = [updatedStory]
        
        let newState = readerReducer(initialState, .onCreatedChapter(updatedStory))
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Story Loading and Management Tests
    
    @Test
    func loadAllStories() {
        let initialState = ReaderState.arrange(isLoading: false)
        
        var expectedState = initialState
        expectedState.isLoading = true
        
        let newState = readerReducer(initialState, .loadAllStories)
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onLoadedStories() {
        let stories = [
            Story(title: "Story 1"),
            Story(title: "Story 2")
        ]
        let initialState = ReaderState.arrange(isLoading: true, loadingStep: .writingChapter)
        
        var expectedState = initialState
        expectedState.loadedStories = stories
        expectedState.isLoading = false
        expectedState.loadingStep = .idle
        
        let newState = readerReducer(initialState, .onLoadedStories(stories))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func setStory() {
        let story = Story(title: "Test Story")
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.story = story
        
        let newState = readerReducer(initialState, .setStory(story))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func setStory_nil() {
        let initialState = ReaderState.arrange(story: Story(title: "Existing Story"))
        
        var expectedState = initialState
        expectedState.story = nil
        
        let newState = readerReducer(initialState, .setStory(nil))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onDeletedStory_removesFromLoadedStories() {
        let storyIdToDelete = UUID()
        let storyToKeep = Story(title: "Keep Story")
        let storyToDelete = Story(id: storyIdToDelete, title: "Delete Story")
        
        let initialState = ReaderState.arrange(
            loadedStories: [storyToKeep, storyToDelete]
        )
        
        var expectedState = initialState
        expectedState.loadedStories = [storyToKeep]
        
        let newState = readerReducer(initialState, .onDeletedStory(storyIdToDelete))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onDeletedStory_clearsCurrentStoryIfDeleted() {
        let storyIdToDelete = UUID()
        let currentStory = Story(id: storyIdToDelete, title: "Current Story")
        
        let initialState = ReaderState.arrange(
            loadedStories: [currentStory],
            story: currentStory
        )
        
        var expectedState = initialState
        expectedState.loadedStories = []
        expectedState.story = nil
        
        let newState = readerReducer(initialState, .onDeletedStory(storyIdToDelete))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onDeletedStory_keepsCurrentStoryIfDifferentId() {
        let currentStoryId = UUID()
        let deletedStoryId = UUID()
        let currentStory = Story(id: currentStoryId, title: "Current Story")
        
        let initialState = ReaderState.arrange(story: currentStory)
        
        var expectedState = initialState
        // No changes expected when deleting a different story
        
        let newState = readerReducer(initialState, .onDeletedStory(deletedStoryId))
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Character and Setting Update Tests
    
    @Test
    func updateMainCharacter() {
        let initialState = ReaderState.arrange(mainCharacter: "Old Character")
        
        var expectedState = initialState
        expectedState.mainCharacter = "New Character"
        
        let newState = readerReducer(initialState, .updateMainCharacter("New Character"))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func updateSetting() {
        let initialState = ReaderState.arrange(setting: "Old Setting")
        
        var expectedState = initialState
        expectedState.setting = "New Setting"
        
        let newState = readerReducer(initialState, .updateSetting("New Setting"))
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Story Navigation Tests
    
    @Test
    func updateChapterIndex_validIndex() {
        let story = Story(chapterIndex: 0, chapters: [
            Chapter(content: ""),
            Chapter(content: ""),
            Chapter(content: "")
        ])
        let initialState = ReaderState.arrange(story: story)
        
        var expectedState = initialState
        expectedState.story?.chapterIndex = 1
        expectedState.story?.scrollOffset = 0
        // The reducer adds the updated story to loadedStories
        expectedState.loadedStories = [expectedState.story!]
        
        let newState = readerReducer(initialState, .updateChapterIndex(story, 1))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func updateChapterIndex_belowZero() {
        let story = Story(chapterIndex: 2, chapters: [
            Chapter(content: "")
        ])
        let initialState = ReaderState.arrange(story: story)
        
        var expectedState = initialState
        expectedState.story?.chapterIndex = 0
        expectedState.story?.scrollOffset = 0
        // The reducer adds the updated story to loadedStories
        expectedState.loadedStories = [expectedState.story!]
        
        let newState = readerReducer(initialState, .updateChapterIndex(story, -1))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func updateChapterIndex_aboveMaximum() {
        let story = Story(chapterIndex: 0, chapters: [
            Chapter(content: ""),
            Chapter(content: "")
        ])
        let initialState = ReaderState.arrange(story: story)
        
        var expectedState = initialState
        expectedState.story?.chapterIndex = 1 // Clamped to max index
        expectedState.story?.scrollOffset = 0
        // The reducer adds the updated story to loadedStories
        expectedState.loadedStories = [expectedState.story!]
        
        let newState = readerReducer(initialState, .updateChapterIndex(story, 5))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func updateChapterIndex_differentStory() {
        let currentStory = Story(id: UUID(), chapterIndex: 0)
        let differentStory = Story(id: UUID(), chapterIndex: 0, chapters: [
            Chapter(content: ""),
            Chapter(content: "")
        ])
        let initialState = ReaderState.arrange(story: currentStory)
        
        var expectedState = initialState
        // Current story should remain unchanged when updating a different story
        expectedState.loadedStories = [differentStory]
        expectedState.loadedStories[0].chapterIndex = 1
        expectedState.loadedStories[0].scrollOffset = 0
        
        let newState = readerReducer(initialState, .updateChapterIndex(differentStory, 1))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func updateScrollOffset() {
        let storyId = UUID()
        let story = Story(id: storyId, scrollOffset: 0)
        let anotherStory = Story(title: "Another Story")
        
        let initialState = ReaderState.arrange(
            loadedStories: [story, anotherStory],
            story: story
        )
        
        var expectedState = initialState
        expectedState.story?.scrollOffset = 100.5
        // Update the story in loadedStories as well
        if let index = expectedState.loadedStories.firstIndex(where: { $0.id == storyId }) {
            expectedState.loadedStories[index].scrollOffset = 100.5
        }
        
        let newState = readerReducer(initialState, .updateScrollOffset(100.5))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func updateScrollOffset_noStory() {
        let initialState = ReaderState.arrange(story: nil)
        
        var expectedState = initialState
        // No change expected when there's no story
        
        let newState = readerReducer(initialState, .updateScrollOffset(100.0))
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Settings and UI State Tests
    
    @Test
    func refreshSettings() {
        let newSettings = SettingsState()
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.settingsState = newSettings
        
        let newState = readerReducer(initialState, .refreshSettings(newSettings))
        
        #expect(newState == expectedState)
    }
    
    @Test(arguments: [
        true,
        false
    ])
    func setShowStoryForm(boolValue: Bool) {
        let initialState = ReaderState.arrange
        var expectedState = initialState
        expectedState.showStoryForm = boolValue
        
        let newState = readerReducer(
            initialState,
            .setShowStoryForm(boolValue)
        )
        #expect(newState == expectedState)
    }
    
    // MARK: - Error Handling Tests
    
    @Test
    func failedToCreateChapter() {
        let initialState = ReaderState.arrange(
            isLoading: true,
            loadingStep: .writingChapter
        )
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.loadingStep = .idle
        
        let newState = readerReducer(initialState, .failedToCreateChapter)
        
        #expect(newState == expectedState)
    }
    
    @Test
    func failedToLoadStories() {
        let initialState = ReaderState.arrange(
            isLoading: true,
            loadingStep: .analyzingStructure
        )
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.loadingStep = .idle
        
        let newState = readerReducer(initialState, .failedToLoadStories)
        
        #expect(newState == expectedState)
    }
    
    @Test(arguments: [
        true,
        false
    ])
    func setShowSubscriptionSheet(boolValue: Bool) {
        let initialState = ReaderState.arrange
        var expectedState = initialState
        expectedState.showSubscriptionSheet = boolValue
        
        let newState = readerReducer(
            initialState,
            .setShowSubscriptionSheet(boolValue)
        )
        #expect(newState == expectedState)
    }
    
    // MARK: - Selected Story for Details Tests
    
    @Test
    func setSelectedStoryForDetails_withStory() {
        let story = Story(title: "Test Story")
        let initialState = ReaderState.arrange
        
        var expectedState = initialState
        expectedState.selectedStoryForDetails = story
        
        let newState = readerReducer(initialState, .setSelectedStoryForDetails(story))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func setSelectedStoryForDetails_withNil() {
        let initialStory = Story(title: "Initial Story")
        let initialState = ReaderState.arrange(selectedStoryForDetails: initialStory)
        
        var expectedState = initialState
        expectedState.selectedStoryForDetails = nil
        
        let newState = readerReducer(initialState, .setSelectedStoryForDetails(nil))
        
        #expect(newState == expectedState)
    }
    
    // MARK: - canCreateChapter Computed Property Tests
    
    @Test
    func canCreateChapter_noStory_returnsTrue() {
        let state = ReaderState.arrange(story: nil)
        #expect(state.canCreateChapter == true)
    }
    
    @Test
    func canCreateChapter_subscribedUser_returnsTrue() {
        let story = Story(chapters: [
            Chapter(content: ""),
            Chapter(content: ""),
            Chapter(content: "")
        ])
        let state = ReaderState.arrange(
            story: story,
            settingsState: SettingsState(isSubscribed: true)
        )
        #expect(state.canCreateChapter == true)
    }
    
    @Test
    func canCreateChapter_unsubscribedUser_lessThan2Chapters_returnsTrue() {
        let story = Story(chapters: [
            Chapter(content: "")
        ])
        let state = ReaderState.arrange(
            story: story,
            settingsState: SettingsState(isSubscribed: false)
        )
        #expect(state.canCreateChapter == true)
    }
    
    @Test
    func canCreateChapter_unsubscribedUser_exactly2Chapters_returnsFalse() {
        let story = Story(chapters: [
            Chapter(content: ""),
            Chapter(content: "")
        ])
        let state = ReaderState.arrange(
            story: story,
            settingsState: SettingsState(isSubscribed: false)
        )
        #expect(state.canCreateChapter == false)
    }
    
    @Test
    func canCreateChapter_unsubscribedUser_moreThan2Chapters_returnsFalse() {
        let story = Story(chapters: [
            Chapter(content: ""),
            Chapter(content: ""),
            Chapter(content: ""),
            Chapter(content: "")
        ])
        let state = ReaderState.arrange(
            story: story,
            settingsState: SettingsState(isSubscribed: false)
        )
        #expect(state.canCreateChapter == false)
    }
    
    // MARK: - Middleware-handled Actions
    
    @Test
    func deleteStory_noStateChange() {
        let initialState = ReaderState.arrange
        let storyId = UUID()
        
        var expectedState = initialState
        // No change expected as deleteStory is handled by middleware
        
        let newState = readerReducer(initialState, .deleteStory(storyId))
        
        #expect(newState == expectedState)
    }
    
    @Test
    func saveStory_noStateChange() {
        let story = Story(title: "Test Story")
        let initialState = ReaderState.arrange(story: story)
        
        var expectedState = initialState
        // No change expected as saveStory is handled by middleware
        
        let newState = readerReducer(initialState, .saveStory(story))
        
        #expect(newState == expectedState)
    }
}
