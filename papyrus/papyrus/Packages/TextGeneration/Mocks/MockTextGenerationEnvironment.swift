//
//  MockTextGenerationEnvironment.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation
@testable import TextGeneration

public class MockTextGenerationEnvironment: TextGenerationEnvironmentProtocol {
    
    // MARK: - Spy Properties for Method Calls
    public var createPlotOutlineCalled = false
    public var createPlotOutlineCalledWith: Story?
    public var createPlotOutlineCallCount = 0
    
    public var createSequelPlotOutlineCalled = false
    public var createSequelPlotOutlineCalledWith: (story: Story, previousStory: Story)?
    public var createSequelPlotOutlineCallCount = 0
    
    public var createChapterBreakdownCalled = false
    public var createChapterBreakdownCalledWith: Story?
    public var createChapterBreakdownCallCount = 0
    
    public var getStoryDetailsCalled = false
    public var getStoryDetailsCalledWith: Story?
    public var getStoryDetailsCallCount = 0
    
    public var getChapterTitleCalled = false
    public var getChapterTitleCalledWith: Story?
    public var getChapterTitleCallCount = 0
    
    public var createChapterCalled = false
    public var createChapterCalledWith: Story?
    public var createChapterCallCount = 0
    
    // MARK: - Return Values and Error Configuration
    public var createPlotOutlineReturnValue: Story?
    public var createPlotOutlineError: Error?
    
    public var createSequelPlotOutlineReturnValue: Story?
    public var createSequelPlotOutlineError: Error?
    
    public var createChapterBreakdownReturnValue: Story?
    public var createChapterBreakdownError: Error?
    
    public var getStoryDetailsReturnValue: Story?
    public var getStoryDetailsError: Error?
    
    public var getChapterTitleReturnValue: Story?
    public var getChapterTitleError: Error?
    
    public var createChapterReturnValue: Story?
    public var createChapterError: Error?
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - TextGenerationEnvironmentProtocol Methods
    
    public func createPlotOutline(story: Story) async throws -> Story {
        createPlotOutlineCalled = true
        createPlotOutlineCalledWith = story
        createPlotOutlineCallCount += 1
        
        if let error = createPlotOutlineError {
            throw error
        }
        
        return createPlotOutlineReturnValue ?? story
    }
    
    public func createSequelPlotOutline(story: Story, previousStory: Story) async throws -> Story {
        createSequelPlotOutlineCalled = true
        createSequelPlotOutlineCalledWith = (story: story, previousStory: previousStory)
        createSequelPlotOutlineCallCount += 1
        
        if let error = createSequelPlotOutlineError {
            throw error
        }
        
        return createSequelPlotOutlineReturnValue ?? story
    }
    
    public func createChapterBreakdown(story: Story) async throws -> Story {
        createChapterBreakdownCalled = true
        createChapterBreakdownCalledWith = story
        createChapterBreakdownCallCount += 1
        
        if let error = createChapterBreakdownError {
            throw error
        }
        
        return createChapterBreakdownReturnValue ?? story
    }
    
    public func getStoryDetails(story: Story) async throws -> Story {
        getStoryDetailsCalled = true
        getStoryDetailsCalledWith = story
        getStoryDetailsCallCount += 1
        
        if let error = getStoryDetailsError {
            throw error
        }
        
        return getStoryDetailsReturnValue ?? story
    }
    
    public func getChapterTitle(story: Story) async throws -> Story {
        getChapterTitleCalled = true
        getChapterTitleCalledWith = story
        getChapterTitleCallCount += 1
        
        if let error = getChapterTitleError {
            throw error
        }
        
        return getChapterTitleReturnValue ?? story
    }
    
    public func createChapter(story: Story) async throws -> Story {
        createChapterCalled = true
        createChapterCalledWith = story
        createChapterCallCount += 1
        
        if let error = createChapterError {
            throw error
        }
        
        return createChapterReturnValue ?? story
    }
    
    // MARK: - Helper Methods
    
    public func reset() {
        createPlotOutlineCalled = false
        createPlotOutlineCalledWith = nil
        createPlotOutlineCallCount = 0
        
        createSequelPlotOutlineCalled = false
        createSequelPlotOutlineCalledWith = nil
        createSequelPlotOutlineCallCount = 0
        
        createChapterBreakdownCalled = false
        createChapterBreakdownCalledWith = nil
        createChapterBreakdownCallCount = 0
        
        getStoryDetailsCalled = false
        getStoryDetailsCalledWith = nil
        getStoryDetailsCallCount = 0
        
        getChapterTitleCalled = false
        getChapterTitleCalledWith = nil
        getChapterTitleCallCount = 0
        
        createChapterCalled = false
        createChapterCalledWith = nil
        createChapterCallCount = 0
        
        createPlotOutlineReturnValue = nil
        createPlotOutlineError = nil
        
        createSequelPlotOutlineReturnValue = nil
        createSequelPlotOutlineError = nil
        
        createChapterBreakdownReturnValue = nil
        createChapterBreakdownError = nil
        
        getStoryDetailsReturnValue = nil
        getStoryDetailsError = nil
        
        getChapterTitleReturnValue = nil
        getChapterTitleError = nil
        
        createChapterReturnValue = nil
        createChapterError = nil
    }
}

// MARK: - Test Error

public struct TextGenerationTestError: Error, Equatable {
    public let message: String
    
    public init(_ message: String = "TextGeneration test error") {
        self.message = message
    }
}