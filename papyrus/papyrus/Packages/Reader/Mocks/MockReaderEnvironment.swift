//
//  MockReaderEnvironment.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation
import TextGeneration
import Settings
import SettingsMocks
import Subscription
import SubscriptionMocks
@testable import Reader

public class MockReaderEnvironment: ReaderEnvironmentProtocol {
    
    // MARK: - Spy Properties for Method Calls
    var createPlotOutlineCalled = false
    var createPlotOutlineCalledWith: Story?
    
    var createSequelPlotOutlineCalled = false
    var createSequelPlotOutlineCalledWith: (story: Story, previousStory: Story)?
    
    var createChapterBreakdownCalled = false
    var createChapterBreakdownCalledWith: Story?
    
    var getStoryDetailsCalled = false
    var getStoryDetailsCalledWith: Story?
    
    var getChapterTitleCalled = false
    var getChapterTitleCalledWith: Story?
    
    var createChapterCalled = false
    var createChapterCalledWith: Story?
    
    var saveStoryCalled = false
    var saveStoryCalledWith: Story?
    var saveStoryCallCount = 0
    var saveStoryCallHistory: [Story] = []
    
    var loadStoryWithIdCalled = false
    var loadStoryWithIdCalledWith: UUID?
    
    var getAllSavedStoryIdsCalled = false
    
    var deleteStoryWithIdCalled = false
    var deleteStoryWithIdCalledWith: UUID?
    
    var loadAllStoriesCalled = false
    
    var loadSubscriptionsCalled = false
    
    // MARK: - Return Values and Error Configuration
    var createPlotOutlineReturnValue: Story?
    var createPlotOutlineError: Error?
    
    var createSequelPlotOutlineReturnValue: Story?
    var createSequelPlotOutlineError: Error?
    
    var createChapterBreakdownReturnValue: Story?
    var createChapterBreakdownError: Error?
    
    var getStoryDetailsReturnValue: Story?
    var getStoryDetailsError: Error?
    
    var getChapterTitleReturnValue: Story?
    var getChapterTitleError: Error?
    
    var createChapterReturnValue: Story?
    var createChapterError: Error?
    
    var saveStoryError: Error?
    
    var loadStoryWithIdReturnValue: Story?
    var loadStoryWithIdError: Error?
    
    var getAllSavedStoryIdsReturnValue: [UUID] = []
    var getAllSavedStoryIdsError: Error?
    
    var deleteStoryWithIdError: Error?
    
    var loadAllStoriesReturnValue: [Story] = []
    var loadAllStoriesError: Error?
    
    // MARK: - Environment Properties
    public var settingsEnvironment: SettingsEnvironmentProtocol
    public var subscriptionEnvironment: SubscriptionEnvironmentProtocol
    
    // MARK: - Initialization
    public init(
        settingsEnvironment: SettingsEnvironmentProtocol = MockSettingsEnvironment(),
        subscriptionEnvironment: SubscriptionEnvironmentProtocol = MockSubscriptionEnvironment()
    ) {
        self.settingsEnvironment = settingsEnvironment
        self.subscriptionEnvironment = subscriptionEnvironment
    }
    
    // MARK: - ReaderEnvironmentProtocol Methods
    
    public func createPlotOutline(story: Story) async throws -> Story {
        createPlotOutlineCalled = true
        createPlotOutlineCalledWith = story
        
        if let error = createPlotOutlineError {
            throw error
        }
        
        return createPlotOutlineReturnValue ?? story
    }
    
    public func createSequelPlotOutline(story: Story, previousStory: Story) async throws -> Story {
        createSequelPlotOutlineCalled = true
        createSequelPlotOutlineCalledWith = (story: story, previousStory: previousStory)
        
        if let error = createSequelPlotOutlineError {
            throw error
        }
        
        return createSequelPlotOutlineReturnValue ?? story
    }
    
    public func createChapterBreakdown(story: Story) async throws -> Story {
        createChapterBreakdownCalled = true
        createChapterBreakdownCalledWith = story
        
        if let error = createChapterBreakdownError {
            throw error
        }
        
        return createChapterBreakdownReturnValue ?? story
    }
    
    public func getStoryDetails(story: Story) async throws -> Story {
        getStoryDetailsCalled = true
        getStoryDetailsCalledWith = story
        
        if let error = getStoryDetailsError {
            throw error
        }
        
        return getStoryDetailsReturnValue ?? story
    }
    
    public func getChapterTitle(story: Story) async throws -> Story {
        getChapterTitleCalled = true
        getChapterTitleCalledWith = story
        
        if let error = getChapterTitleError {
            throw error
        }
        
        return getChapterTitleReturnValue ?? story
    }
    
    public func createChapter(story: Story) async throws -> Story {
        createChapterCalled = true
        createChapterCalledWith = story
        
        if let error = createChapterError {
            throw error
        }
        
        return createChapterReturnValue ?? story
    }
    
    public func saveStory(_ story: Story) async throws {
        saveStoryCalled = true
        saveStoryCalledWith = story
        saveStoryCallCount += 1
        saveStoryCallHistory.append(story)
        
        if let error = saveStoryError {
            throw error
        }
    }
    
    public func loadStory(withId id: UUID) async throws -> Story? {
        loadStoryWithIdCalled = true
        loadStoryWithIdCalledWith = id
        
        if let error = loadStoryWithIdError {
            throw error
        }
        
        return loadStoryWithIdReturnValue
    }
    
    public func getAllSavedStoryIds() async throws -> [UUID] {
        getAllSavedStoryIdsCalled = true
        
        if let error = getAllSavedStoryIdsError {
            throw error
        }
        
        return getAllSavedStoryIdsReturnValue
    }
    
    public func deleteStory(withId id: UUID) async throws {
        deleteStoryWithIdCalled = true
        deleteStoryWithIdCalledWith = id
        
        if let error = deleteStoryWithIdError {
            throw error
        }
    }
    
    public func loadAllStories() async throws -> [Story] {
        loadAllStoriesCalled = true
        
        if let error = loadAllStoriesError {
            throw error
        }
        
        return loadAllStoriesReturnValue
    }
    
    public func loadSubscriptions() async {
        loadSubscriptionsCalled = true
    }
}

// MARK: - Test Error

public struct ReaderTestError: Error, Equatable {
    public let message: String
    
    public init(_ message: String = "Reader test error") {
        self.message = message
    }
}
