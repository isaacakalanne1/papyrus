//
//  MockReaderDataStore.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation
import TextGeneration
@testable import Reader

public class MockReaderDataStore: ReaderDataStoreProtocol {
    
    // MARK: - Spy Properties for Method Calls
    public var saveStoryCalled = false
    public var saveStoryCalledWith: Story?
    public var saveStoryCallCount = 0
    public var saveStoryCallHistory: [Story] = []
    
    public var loadStoryWithIdCalled = false
    public var loadStoryWithIdCalledWith: UUID?
    public var loadStoryWithIdCallCount = 0
    public var loadStoryWithIdCallHistory: [UUID] = []
    
    public var getAllSavedStoryIdsCalled = false
    public var getAllSavedStoryIdsCallCount = 0
    
    public var deleteStoryWithIdCalled = false
    public var deleteStoryWithIdCalledWith: UUID?
    public var deleteStoryWithIdCallCount = 0
    public var deleteStoryWithIdCallHistory: [UUID] = []
    
    // MARK: - Return Values and Error Configuration
    public var saveStoryError: Error?
    
    public var loadStoryWithIdReturnValue: Story?
    public var loadStoryWithIdError: Error?
    
    public var getAllSavedStoryIdsReturnValue: [UUID] = []
    public var getAllSavedStoryIdsError: Error?
    
    public var deleteStoryWithIdError: Error?
    
    // MARK: - Storage for Testing
    public var stories: [UUID: Story] = [:]
    public var storyIds: [UUID] = []
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - ReaderDataStoreProtocol Methods
    
    public func saveStory(_ story: Story) async throws {
        saveStoryCalled = true
        saveStoryCalledWith = story
        saveStoryCallCount += 1
        saveStoryCallHistory.append(story)
        
        if let error = saveStoryError {
            throw error
        }
        
        // Update internal storage for realistic behavior
        stories[story.id] = story
        if !storyIds.contains(story.id) {
            storyIds.append(story.id)
        }
    }
    
    public func loadStory(withId id: UUID) async throws -> Story? {
        loadStoryWithIdCalled = true
        loadStoryWithIdCalledWith = id
        loadStoryWithIdCallCount += 1
        loadStoryWithIdCallHistory.append(id)
        
        if let error = loadStoryWithIdError {
            throw error
        }
        
        // Return configured return value or check internal storage
        if let returnValue = loadStoryWithIdReturnValue {
            return returnValue
        }
        
        return stories[id]
    }
    
    public func getAllSavedStoryIds() async throws -> [UUID] {
        getAllSavedStoryIdsCalled = true
        getAllSavedStoryIdsCallCount += 1
        
        if let error = getAllSavedStoryIdsError {
            throw error
        }
        
        // Return configured return value or internal storage
        if !getAllSavedStoryIdsReturnValue.isEmpty {
            return getAllSavedStoryIdsReturnValue
        }
        
        return storyIds
    }
    
    public func deleteStory(withId id: UUID) async throws {
        deleteStoryWithIdCalled = true
        deleteStoryWithIdCalledWith = id
        deleteStoryWithIdCallCount += 1
        deleteStoryWithIdCallHistory.append(id)
        
        if let error = deleteStoryWithIdError {
            throw error
        }
        
        // Update internal storage for realistic behavior
        stories.removeValue(forKey: id)
        storyIds.removeAll { $0 == id }
    }
    
    // MARK: - Helper Methods
    
    public func reset() {
        saveStoryCalled = false
        saveStoryCalledWith = nil
        saveStoryCallCount = 0
        saveStoryCallHistory.removeAll()
        
        loadStoryWithIdCalled = false
        loadStoryWithIdCalledWith = nil
        loadStoryWithIdCallCount = 0
        loadStoryWithIdCallHistory.removeAll()
        
        getAllSavedStoryIdsCalled = false
        getAllSavedStoryIdsCallCount = 0
        
        deleteStoryWithIdCalled = false
        deleteStoryWithIdCalledWith = nil
        deleteStoryWithIdCallCount = 0
        deleteStoryWithIdCallHistory.removeAll()
        
        saveStoryError = nil
        loadStoryWithIdReturnValue = nil
        loadStoryWithIdError = nil
        getAllSavedStoryIdsReturnValue = []
        getAllSavedStoryIdsError = nil
        deleteStoryWithIdError = nil
        
        stories.removeAll()
        storyIds.removeAll()
    }
    
    public func addStory(_ story: Story) {
        stories[story.id] = story
        if !storyIds.contains(story.id) {
            storyIds.append(story.id)
        }
    }
}