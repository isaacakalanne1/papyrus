//
//  ReaderEnvironmentTests.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import Foundation
@testable import TextGeneration
import TextGenerationMocks
import Settings
import SettingsMocks
import Subscription
import SubscriptionMocks
@testable import Reader
@testable import ReaderMocks

class ReaderEnvironmentTests {
    
    // MARK: - Text Generation Methods Tests
    
    @Test
    func createPlotOutline_callsTextGenerationEnvironment() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let inputStory = Story(title: "Test Story")
        let outputStory = Story(plotOutline: "Test plot", title: "Output Story")
        mockTextGeneration.createPlotOutlineReturnValue = outputStory
        
        let result = try await environment.createPlotOutline(story: inputStory)
        
        #expect(mockTextGeneration.createPlotOutlineCalled)
        #expect(mockTextGeneration.createPlotOutlineCalledWith?.id == inputStory.id)
        #expect(result.id == outputStory.id)
        #expect(result.plotOutline == "Test plot")
    }
    
    @Test
    func createPlotOutline_throwsError() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let inputStory = Story(title: "Test Story")
        let testError = TextGenerationTestError("Plot outline failed")
        mockTextGeneration.createPlotOutlineError = testError
        
        await #expect(throws: TextGenerationTestError.self) {
            try await environment.createPlotOutline(story: inputStory)
        }
        
        #expect(mockTextGeneration.createPlotOutlineCalled)
    }
    
    @Test
    func createSequelPlotOutline_callsTextGenerationEnvironment() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let inputStory = Story(title: "Sequel Story")
        let previousStory = Story(title: "Previous Story")
        let outputStory = Story(plotOutline: "Sequel plot", title: "Output Sequel")
        mockTextGeneration.createSequelPlotOutlineReturnValue = outputStory
        
        let result = try await environment.createSequelPlotOutline(story: inputStory, previousStory: previousStory)
        
        #expect(mockTextGeneration.createSequelPlotOutlineCalled)
        #expect(mockTextGeneration.createSequelPlotOutlineCalledWith?.story.id == inputStory.id)
        #expect(mockTextGeneration.createSequelPlotOutlineCalledWith?.previousStory.id == previousStory.id)
        #expect(result.id == outputStory.id)
    }
    
    @Test
    func createChapterBreakdown_callsTextGenerationEnvironment() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let inputStory = Story(title: "Test Story")
        let outputStory = Story(chaptersBreakdown: "Test breakdown", title: "Output Story")
        mockTextGeneration.createChapterBreakdownReturnValue = outputStory
        
        let result = try await environment.createChapterBreakdown(story: inputStory)
        
        #expect(mockTextGeneration.createChapterBreakdownCalled)
        #expect(mockTextGeneration.createChapterBreakdownCalledWith?.id == inputStory.id)
        #expect(result.chaptersBreakdown == "Test breakdown")
    }
    
    @Test
    func getStoryDetails_callsTextGenerationEnvironment() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let inputStory = Story(title: "Test Story")
        let outputStory = Story(setting: "Test details", title: "Output Story")
        mockTextGeneration.getStoryDetailsReturnValue = outputStory
        
        let result = try await environment.getStoryDetails(story: inputStory)
        
        #expect(mockTextGeneration.getStoryDetailsCalled)
        #expect(mockTextGeneration.getStoryDetailsCalledWith?.id == inputStory.id)
        #expect(result.setting == "Test details")
    }
    
    @Test
    func getChapterTitle_callsTextGenerationEnvironment() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let inputStory = Story(title: "Test Story")
        let outputStory = Story(title: "Output Story", chapters: [
            Chapter(title: "Chapter 1", content: "")
        ])
        mockTextGeneration.getChapterTitleReturnValue = outputStory
        
        let result = try await environment.getChapterTitle(story: inputStory)
        
        #expect(mockTextGeneration.getChapterTitleCalled)
        #expect(mockTextGeneration.getChapterTitleCalledWith?.id == inputStory.id)
        #expect(result.chapters.count == 1)
        #expect(result.chapters.first?.title == "Chapter 1")
    }
    
    @Test
    func createChapter_callsTextGenerationEnvironment() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let inputStory = Story(title: "Test Story")
        let outputStory = Story(title: "Output Story", chapters: [
            Chapter(title: "New Chapter", content: "Chapter content")
        ])
        mockTextGeneration.createChapterReturnValue = outputStory
        
        let result = try await environment.createChapter(story: inputStory)
        
        #expect(mockTextGeneration.createChapterCalled)
        #expect(mockTextGeneration.createChapterCalledWith?.id == inputStory.id)
        #expect(result.chapters.count == 1)
        #expect(result.chapters.first?.content == "Chapter content")
    }
    
    // MARK: - Data Store Methods Tests
    
    @Test
    func saveStory_callsDataStore() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let story = Story(title: "Test Story")
        
        try await environment.saveStory(story)
        
        #expect(mockDataStore.saveStoryCalled)
        #expect(mockDataStore.saveStoryCalledWith?.id == story.id)
    }
    
    @Test
    func saveStory_throwsError() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let story = Story(title: "Test Story")
        let testError = ReaderTestError("Save failed")
        mockDataStore.saveStoryError = testError
        
        await #expect(throws: ReaderTestError.self) {
            try await environment.saveStory(story)
        }
        
        #expect(mockDataStore.saveStoryCalled)
    }
    
    @Test
    func loadStory_callsDataStore() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let storyId = UUID()
        let expectedStory = Story(id: storyId, title: "Test Story")
        mockDataStore.loadStoryWithIdReturnValue = expectedStory
        
        let result = try await environment.loadStory(withId: storyId)
        
        #expect(mockDataStore.loadStoryWithIdCalled)
        #expect(mockDataStore.loadStoryWithIdCalledWith == storyId)
        #expect(result?.id == expectedStory.id)
        #expect(result?.title == "Test Story")
    }
    
    @Test
    func loadStory_returnsNil() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let storyId = UUID()
        mockDataStore.loadStoryWithIdReturnValue = nil
        
        let result = try await environment.loadStory(withId: storyId)
        
        #expect(mockDataStore.loadStoryWithIdCalled)
        #expect(result == nil)
    }
    
    @Test
    func getAllSavedStoryIds_callsDataStore() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let expectedIds = [UUID(), UUID(), UUID()]
        mockDataStore.getAllSavedStoryIdsReturnValue = expectedIds
        
        let result = try await environment.getAllSavedStoryIds()
        
        #expect(mockDataStore.getAllSavedStoryIdsCalled)
        #expect(result.count == 3)
        #expect(result == expectedIds)
    }
    
    @Test
    func deleteStory_callsDataStore() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let storyId = UUID()
        
        try await environment.deleteStory(withId: storyId)
        
        #expect(mockDataStore.deleteStoryWithIdCalled)
        #expect(mockDataStore.deleteStoryWithIdCalledWith == storyId)
    }
    
    @Test
    func loadAllStories_loadsAllStoriesFromIds() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let story1 = Story(title: "Story 1")
        let story2 = Story(title: "Story 2")
        let story3 = Story(title: "Story 3")
        
        // Setup mock data store with stories
        mockDataStore.addStory(story1)
        mockDataStore.addStory(story2)
        mockDataStore.addStory(story3)
        
        let result = try await environment.loadAllStories()
        
        #expect(mockDataStore.getAllSavedStoryIdsCalled)
        #expect(mockDataStore.loadStoryWithIdCallCount == 3)
        #expect(result.count == 3)
        
        let resultTitles = result.map { $0.title }.sorted()
        #expect(resultTitles == ["Story 1", "Story 2", "Story 3"])
    }
    
    @Test
    func loadAllStories_skipsNilStories() async throws {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        let story1 = Story(title: "Story 1")
        let missingStoryId = UUID()
        
        // Setup mock data store
        mockDataStore.addStory(story1)
        mockDataStore.storyIds.append(missingStoryId) // Add ID but not the story
        
        let result = try await environment.loadAllStories()
        
        #expect(mockDataStore.getAllSavedStoryIdsCalled)
        #expect(mockDataStore.loadStoryWithIdCallCount == 2) // Called for both IDs
        #expect(result.count == 1) // Only one story returned (nil skipped)
        #expect(result.first?.title == "Story 1")
    }
    
    // MARK: - Subscription Methods Tests
    
    @Test
    func loadSubscriptions_callsSubscriptionEnvironment() async {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        await environment.loadSubscriptions()
        
        #expect(mockSubscription.loadSubscriptionOnInitCalled)
    }
    
    // MARK: - Environment Properties Tests
    
    @Test
    func environmentProperties_areAccessible() {
        let mockTextGeneration = MockTextGenerationEnvironment()
        let mockSettings = MockSettingsEnvironment()
        let mockSubscription = MockSubscriptionEnvironment()
        let mockDataStore = MockReaderDataStore()
        
        let environment = ReaderEnvironment(
            dataStore: mockDataStore,
            textGenerationEnvironment: mockTextGeneration,
            settingsEnvironment: mockSettings,
            subscriptionEnvironment: mockSubscription
        )
        
        // Test that properties are accessible and of correct type
        #expect(environment.settingsEnvironment is MockSettingsEnvironment)
        #expect(environment.subscriptionEnvironment is MockSubscriptionEnvironment)
    }
}
