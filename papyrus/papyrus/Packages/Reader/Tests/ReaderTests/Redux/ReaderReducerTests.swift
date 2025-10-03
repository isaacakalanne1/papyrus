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
    func createStory() {
        let initialState = ReaderState(
            mainCharacter: "John Doe",
            setting: "Modern City"
        )
        
        let newState = readerReducer(initialState, .createStory)
        
        #expect(newState.isLoading == true)
        #expect(newState.loadingStep == .creatingPlotOutline)
        #expect(newState.story?.mainCharacter == "John Doe")
        #expect(newState.story?.setting == "Modern City")
        #expect(newState.story?.id != nil)
    }
    
    @Test
    func createSequel() {
        let originalStoryId = UUID()
        let originalStory = Story(
            id: originalStoryId,
            mainCharacter: "Original Character",
            setting: "Original Setting",
            title: "Original Story"
        )
        
        let initialState = ReaderState(
            mainCharacter: "Sequel Character",
            setting: "Sequel Setting",
            story: originalStory
        )
        
        let newState = readerReducer(initialState, .createSequel)
        
        #expect(newState.isLoading == true)
        #expect(newState.loadingStep == .creatingPlotOutline)
        #expect(newState.sequelStory?.mainCharacter == "Sequel Character")
        #expect(newState.sequelStory?.setting == "Sequel Setting")
        #expect(newState.sequelStory?.id != originalStoryId)
        #expect(newState.sequelStory?.chapters.isEmpty == true)
        #expect(newState.sequelStory?.chapterIndex == 0)
        #expect(newState.sequelStory?.prequelIds.contains(originalStoryId) == true)
    }
    
    // MARK: - Plot and Chapter Creation Tests
    
    @Test
    func createPlotOutline() {
        let initialState = ReaderState()
        
        let newState = readerReducer(initialState, .createPlotOutline(Story()))
        
        #expect(newState.isLoading == true)
        #expect(newState.loadingStep == .creatingPlotOutline)
    }
    
    @Test
    func onCreatedPlotOutline() {
        let initialState = ReaderState(isLoading: false)
        
        let newState = readerReducer(initialState, .onCreatedPlotOutline(Story()))
        
        #expect(newState.isLoading == true)
    }
    
    @Test
    func createChapterBreakdown() {
        let initialState = ReaderState()
        
        let newState = readerReducer(initialState, .createChapterBreakdown(Story()))
        
        #expect(newState.isLoading == true)
        #expect(newState.loadingStep == .creatingChapterBreakdown)
    }
    
    @Test
    func onCreatedChapterBreakdown() {
        let initialState = ReaderState(isLoading: false)
        
        let newState = readerReducer(initialState, .onCreatedChapterBreakdown(Story()))
        
        #expect(newState.isLoading == true)
    }
    
    @Test
    func getStoryDetails() {
        let initialState = ReaderState()
        
        let newState = readerReducer(initialState, .getStoryDetails(Story()))
        
        #expect(newState.isLoading == true)
        #expect(newState.loadingStep == .analyzingStructure)
    }
    
    @Test
    func onGetStoryDetails() {
        let initialState = ReaderState(isLoading: false)
        
        let newState = readerReducer(initialState, .onGetStoryDetails(Story()))
        
        #expect(newState.isLoading == true)
    }
    
    @Test
    func getChapterTitle() {
        let initialState = ReaderState()
        
        let newState = readerReducer(initialState, .getChapterTitle(Story()))
        
        #expect(newState.isLoading == true)
        #expect(newState.loadingStep == .preparingNarrative)
    }
    
    @Test
    func onGetChapterTitle() {
        let initialState = ReaderState(isLoading: false)
        
        let newState = readerReducer(initialState, .onGetChapterTitle(Story()))
        
        #expect(newState.isLoading == true)
    }
    
    @Test
    func createChapter() {
        let initialState = ReaderState()
        
        let newState = readerReducer(initialState, .createChapter(Story()))
        
        #expect(newState.isLoading == true)
        #expect(newState.loadingStep == .writingChapter)
    }
    
    @Test
    func onCreatedChapter_withMatchingStoryId() {
        let storyId = UUID()
        let existingStory = Story(id: storyId, title: "Existing Story")
        let updatedStory = Story(id: storyId, title: "Updated Story")
        
        let initialState = ReaderState(
            story: existingStory,
            isLoading: true,
            loadingStep: .writingChapter
        )
        
        let newState = readerReducer(initialState, .onCreatedChapter(updatedStory))
        
        #expect(newState.story?.title == "Updated Story")
        #expect(newState.isLoading == false)
        #expect(newState.loadingStep == .idle)
        #expect(newState.loadedStories.contains(updatedStory))
    }
    
    @Test
    func onCreatedChapter_withDifferentStoryId() {
        let currentStoryId = UUID()
        let differentStoryId = UUID()
        let currentStory = Story(id: currentStoryId, title: "Current Story")
        let updatedStory = Story(id: differentStoryId, title: "Different Story")
        
        let initialState = ReaderState(
            story: currentStory,
            isLoading: true,
            loadingStep: .writingChapter
        )
        
        let newState = readerReducer(initialState, .onCreatedChapter(updatedStory))
        
        #expect(newState.story?.title == "Current Story")
        #expect(newState.isLoading == false)
        #expect(newState.loadingStep == .idle)
        #expect(newState.loadedStories.contains(updatedStory))
    }
    
    @Test
    func onCreatedChapter_updatesExistingInLoadedStories() {
        let storyId = UUID()
        let existingStory = Story(id: storyId, title: "Old Title")
        let updatedStory = Story(id: storyId, title: "New Title")
        
        let initialState = ReaderState(
            loadedStories: [existingStory],
            isLoading: true
        )
        
        let newState = readerReducer(initialState, .onCreatedChapter(updatedStory))
        
        #expect(newState.loadedStories.count == 1)
        #expect(newState.loadedStories.first?.title == "New Title")
    }
    
    // MARK: - Story Loading and Management Tests
    
    @Test
    func loadAllStories() {
        let initialState = ReaderState(isLoading: false)
        
        let newState = readerReducer(initialState, .loadAllStories)
        
        #expect(newState.isLoading == true)
    }
    
    @Test
    func onLoadedStories() {
        let stories = [
            Story(title: "Story 1"),
            Story(title: "Story 2")
        ]
        let initialState = ReaderState(isLoading: true, loadingStep: .writingChapter)
        
        let newState = readerReducer(initialState, .onLoadedStories(stories))
        
        #expect(newState.loadedStories == stories)
        #expect(newState.isLoading == false)
        #expect(newState.loadingStep == .idle)
    }
    
    @Test
    func setStory() {
        let story = Story(title: "Test Story")
        let initialState = ReaderState()
        
        let newState = readerReducer(initialState, .setStory(story))
        
        #expect(newState.story == story)
    }
    
    @Test
    func setStory_nil() {
        let initialState = ReaderState(story: Story(title: "Existing Story"))
        
        let newState = readerReducer(initialState, .setStory(nil))
        
        #expect(newState.story == nil)
    }
    
    @Test
    func onDeletedStory_removesFromLoadedStories() {
        let storyIdToDelete = UUID()
        let storyToKeep = Story(title: "Keep Story")
        let storyToDelete = Story(id: storyIdToDelete, title: "Delete Story")
        
        let initialState = ReaderState(
            loadedStories: [storyToKeep, storyToDelete]
        )
        
        let newState = readerReducer(initialState, .onDeletedStory(storyIdToDelete))
        
        #expect(newState.loadedStories.count == 1)
        #expect(newState.loadedStories.first?.title == "Keep Story")
    }
    
    @Test
    func onDeletedStory_clearsCurrentStoryIfDeleted() {
        let storyIdToDelete = UUID()
        let currentStory = Story(id: storyIdToDelete, title: "Current Story")
        
        let initialState = ReaderState(
            loadedStories: [currentStory],
            story: currentStory
        )
        
        let newState = readerReducer(initialState, .onDeletedStory(storyIdToDelete))
        
        #expect(newState.story == nil)
        #expect(newState.loadedStories.isEmpty)
    }
    
    @Test
    func onDeletedStory_keepsCurrentStoryIfDifferentId() {
        let currentStoryId = UUID()
        let deletedStoryId = UUID()
        let currentStory = Story(id: currentStoryId, title: "Current Story")
        
        let initialState = ReaderState(story: currentStory)
        
        let newState = readerReducer(initialState, .onDeletedStory(deletedStoryId))
        
        #expect(newState.story == currentStory)
    }
    
    // MARK: - Character and Setting Update Tests
    
    @Test
    func updateMainCharacter() {
        let initialState = ReaderState(mainCharacter: "Old Character")
        
        let newState = readerReducer(initialState, .updateMainCharacter("New Character"))
        
        #expect(newState.mainCharacter == "New Character")
    }
    
    @Test
    func updateSetting() {
        let initialState = ReaderState(setting: "Old Setting")
        
        let newState = readerReducer(initialState, .updateSetting("New Setting"))
        
        #expect(newState.setting == "New Setting")
    }
    
    // MARK: - Story Navigation Tests
    
    @Test
    func updateChapterIndex_validIndex() {
        let story = Story(chapterIndex: 0, chapters: [
            Chapter(title: "Chapter 1", content: ""),
            Chapter(title: "Chapter 2", content: ""),
            Chapter(title: "Chapter 3", content: "")
        ])
        let initialState = ReaderState(story: story)
        
        let newState = readerReducer(initialState, .updateChapterIndex(1))
        
        #expect(newState.story?.chapterIndex == 1)
        #expect(newState.story?.scrollOffset == 0)
    }
    
    @Test
    func updateChapterIndex_belowZero() {
        let story = Story(chapterIndex: 2, chapters: [
            Chapter(title: "Chapter 1", content: "")
        ])
        let initialState = ReaderState(story: story)
        
        let newState = readerReducer(initialState, .updateChapterIndex(-1))
        
        #expect(newState.story?.chapterIndex == 0)
    }
    
    @Test
    func updateChapterIndex_aboveMaximum() {
        let story = Story(chapterIndex: 0, chapters: [
            Chapter(title: "Chapter 1", content: ""),
            Chapter(title: "Chapter 2", content: "")
        ])
        let initialState = ReaderState(story: story)
        
        let newState = readerReducer(initialState, .updateChapterIndex(5))
        
        #expect(newState.story?.chapterIndex == 1)
    }
    
    @Test
    func updateChapterIndex_noStory() {
        let initialState = ReaderState(story: nil)
        
        let newState = readerReducer(initialState, .updateChapterIndex(1))
        
        #expect(newState.story == nil)
    }
    
    @Test
    func updateScrollOffset() {
        let storyId = UUID()
        let story = Story(id: storyId, scrollOffset: 0)
        let anotherStory = Story(title: "Another Story")
        
        let initialState = ReaderState(
            loadedStories: [story, anotherStory],
            story: story
        )
        
        let newState = readerReducer(initialState, .updateScrollOffset(100.5))
        
        #expect(newState.story?.scrollOffset == 100.5)
        
        let updatedStoryInLoaded = newState.loadedStories.first { $0.id == storyId }
        #expect(updatedStoryInLoaded?.scrollOffset == 100.5)
    }
    
    @Test
    func updateScrollOffset_noStory() {
        let initialState = ReaderState(story: nil)
        
        let newState = readerReducer(initialState, .updateScrollOffset(100.0))
        
        #expect(newState.story == nil)
    }
    
    // MARK: - Settings and UI State Tests
    
    @Test
    func refreshSettings() {
        let newSettings = SettingsState()
        let initialState = ReaderState()
        
        let newState = readerReducer(initialState, .refreshSettings(newSettings))
        
        #expect(newState.settingsState == newSettings)
    }
    
    @Test(arguments: [
        true,
        false
    ])
    func setShowStoryForm(boolValue: Bool) {
        let initialState = ReaderState()
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
        let initialState = ReaderState(
            isLoading: true,
            loadingStep: .writingChapter
        )
        
        let newState = readerReducer(initialState, .failedToCreateChapter)
        
        #expect(newState.isLoading == false)
        #expect(newState.loadingStep == .idle)
    }
    
    @Test
    func failedToLoadStories() {
        let initialState = ReaderState(
            isLoading: true,
            loadingStep: .analyzingStructure
        )
        
        let newState = readerReducer(initialState, .failedToLoadStories)
        
        #expect(newState.isLoading == false)
        #expect(newState.loadingStep == .idle)
    }
    
    // MARK: - Middleware-handled Actions
    
    @Test
    func deleteStory_noStateChange() {
        let initialState = ReaderState()
        let storyId = UUID()
        
        let newState = readerReducer(initialState, .deleteStory(storyId))
        
        #expect(newState == initialState)
    }
}
