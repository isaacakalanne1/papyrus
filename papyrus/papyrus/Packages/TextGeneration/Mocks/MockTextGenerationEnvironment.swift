//
//  MockTextGenerationEnvironment.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation
import TextGeneration

public class MockTextGenerationEnvironment: TextGenerationEnvironmentProtocol {
    // MARK: - Spy Properties for Method Calls

    public var createStoryThemeCalled = false
    public var createStoryThemeCalledWith: Story?
    public var createStoryThemeCallCount = 0

    public var createPlotOutlineCalled = false
    public var createPlotOutlineCalledWith: Story?
    public var createPlotOutlineCallCount = 0

    public var condensePlotOutlineCalled = false
    public var condensePlotOutlineCalledWith: Story?
    public var condensePlotOutlineCallCount = 0

    public var createSequelPlotOutlineCalled = false
    public var createSequelPlotOutlineCalledWith: (story: Story, previousStory: Story)?
    public var createSequelPlotOutlineCallCount = 0

    public var createChapterBreakdownCalled = false
    public var createChapterBreakdownCalledWith: Story?
    public var createChapterBreakdownCallCount = 0

    public var parseChapterSummariesCalled = false
    public var parseChapterSummariesCalledWith: Story?
    public var parseChapterSummariesCallCount = 0

    public var getStoryDetailsCalled = false
    public var getStoryDetailsCalledWith: Story?
    public var getStoryDetailsCallCount = 0

    public var getChapterTitleCalled = false
    public var getChapterTitleCalledWith: Story?
    public var getChapterTitleCallCount = 0

    public var createChapterCalled = false
    public var createChapterCalledWith: Story?
    public var createChapterCallCount = 0

    public var generateParagraphCalled = false
    public var generateParagraphCalledWith: Story?
    public var generateParagraphCalledWithSentenceCount: Int?
    public var generateParagraphCallCount = 0

    // MARK: - Return Values and Error Configuration

    public var createStoryThemeReturnValue: Story?
    public var createStoryThemeError: Error?

    public var createPlotOutlineReturnValue: Story?
    public var createPlotOutlineError: Error?

    public var condensePlotOutlineReturnValue: Story?
    public var condensePlotOutlineError: Error?

    public var createSequelPlotOutlineReturnValue: Story?
    public var createSequelPlotOutlineError: Error?

    public var createChapterBreakdownReturnValue: Story?
    public var createChapterBreakdownError: Error?

    public var parseChapterSummariesReturnValue: Story?
    public var parseChapterSummariesError: Error?

    public var getStoryDetailsReturnValue: Story?
    public var getStoryDetailsError: Error?

    public var getChapterTitleReturnValue: Story?
    public var getChapterTitleError: Error?

    public var createChapterReturnValue: Story?
    public var createChapterError: Error?

    public var generateParagraphReturnValue: Story?
    public var generateParagraphError: Error?

    // MARK: - Initialization

    public init() {}

    // MARK: - TextGenerationEnvironmentProtocol Methods

    public func createStoryTheme(story: Story) async throws -> Story {
        createStoryThemeCalled = true
        createStoryThemeCalledWith = story
        createStoryThemeCallCount += 1

        if let error = createStoryThemeError {
            throw error
        }

        return createStoryThemeReturnValue ?? story
    }

    public func createPlotOutline(story: Story) async throws -> Story {
        createPlotOutlineCalled = true
        createPlotOutlineCalledWith = story
        createPlotOutlineCallCount += 1

        if let error = createPlotOutlineError {
            throw error
        }

        return createPlotOutlineReturnValue ?? story
    }

    public func condensePlotOutline(story: Story) async throws -> Story {
        condensePlotOutlineCalled = true
        condensePlotOutlineCalledWith = story
        condensePlotOutlineCallCount += 1

        if let error = condensePlotOutlineError {
            throw error
        }

        return condensePlotOutlineReturnValue ?? story
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

    public func parseChapterSummaries(story: Story) async throws -> Story {
        parseChapterSummariesCalled = true
        parseChapterSummariesCalledWith = story
        parseChapterSummariesCallCount += 1

        if let error = parseChapterSummariesError {
            throw error
        }

        return parseChapterSummariesReturnValue ?? story
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

    public func generateParagraph(story: Story, sentenceCount: Int) async throws -> Story {
        generateParagraphCalled = true
        generateParagraphCalledWith = story
        generateParagraphCalledWithSentenceCount = sentenceCount
        generateParagraphCallCount += 1

        if let error = generateParagraphError {
            throw error
        }

        return generateParagraphReturnValue ?? story
    }

    // MARK: - Helper Methods

    public func reset() {
        createStoryThemeCalled = false
        createStoryThemeCalledWith = nil
        createStoryThemeCallCount = 0

        createPlotOutlineCalled = false
        createPlotOutlineCalledWith = nil
        createPlotOutlineCallCount = 0

        condensePlotOutlineCalled = false
        condensePlotOutlineCalledWith = nil
        condensePlotOutlineCallCount = 0

        createSequelPlotOutlineCalled = false
        createSequelPlotOutlineCalledWith = nil
        createSequelPlotOutlineCallCount = 0

        createChapterBreakdownCalled = false
        createChapterBreakdownCalledWith = nil
        createChapterBreakdownCallCount = 0

        parseChapterSummariesCalled = false
        parseChapterSummariesCalledWith = nil
        parseChapterSummariesCallCount = 0

        getStoryDetailsCalled = false
        getStoryDetailsCalledWith = nil
        getStoryDetailsCallCount = 0

        getChapterTitleCalled = false
        getChapterTitleCalledWith = nil
        getChapterTitleCallCount = 0

        createChapterCalled = false
        createChapterCalledWith = nil
        createChapterCallCount = 0

        createStoryThemeReturnValue = nil
        createStoryThemeError = nil

        createPlotOutlineReturnValue = nil
        createPlotOutlineError = nil

        condensePlotOutlineReturnValue = nil
        condensePlotOutlineError = nil

        createSequelPlotOutlineReturnValue = nil
        createSequelPlotOutlineError = nil

        createChapterBreakdownReturnValue = nil
        createChapterBreakdownError = nil

        parseChapterSummariesReturnValue = nil
        parseChapterSummariesError = nil

        getStoryDetailsReturnValue = nil
        getStoryDetailsError = nil

        getChapterTitleReturnValue = nil
        getChapterTitleError = nil

        createChapterReturnValue = nil
        createChapterError = nil

        generateParagraphCalled = false
        generateParagraphCalledWith = nil
        generateParagraphCalledWithSentenceCount = nil
        generateParagraphCallCount = 0
        generateParagraphReturnValue = nil
        generateParagraphError = nil
    }
}

// MARK: - Test Error

public struct TextGenerationTestError: Error, Equatable {
    public let message: String

    public init(_ message: String = "TextGeneration test error") {
        self.message = message
    }
}
