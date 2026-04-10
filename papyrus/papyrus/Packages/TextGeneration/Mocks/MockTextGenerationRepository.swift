//
//  MockTextGenerationRepository.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
@testable import TextGeneration

public class MockTextGenerationRepository: TextGenerationRepositoryProtocol {
    // MARK: - Spy Properties for Method Calls

    public var createStoryThemeCalled = false
    public var createStoryThemeCalledWith: Story?
    public var createStoryThemeCallCount = 0

    public var createPlotOutlineCalled = false
    public var createPlotOutlineCalledWith: Story?
    public var createPlotOutlineCallCount = 0

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
    public var generateParagraphCallCount = 0

    // MARK: - Return Values and Error Configuration

    public var createStoryThemeReturnValue: Story?
    public var createStoryThemeError: Error?

    public var createPlotOutlineReturnValue: Story?
    public var createPlotOutlineError: Error?

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

    // MARK: - TextGenerationRepositoryProtocol Methods

    public func createStoryTheme(story originalStory: Story) async throws -> Story {
        createStoryThemeCalled = true
        createStoryThemeCalledWith = originalStory
        createStoryThemeCallCount += 1

        if let error = createStoryThemeError {
            throw error
        }

        return createStoryThemeReturnValue ?? originalStory
    }

    public func createPlotOutline(story originalStory: Story) async throws -> Story {
        createPlotOutlineCalled = true
        createPlotOutlineCalledWith = originalStory
        createPlotOutlineCallCount += 1

        if let error = createPlotOutlineError {
            throw error
        }

        return createPlotOutlineReturnValue ?? originalStory
    }

    public func createSequelPlotOutline(story originalStory: Story, previousStory: Story) async throws -> Story {
        createSequelPlotOutlineCalled = true
        createSequelPlotOutlineCalledWith = (story: originalStory, previousStory: previousStory)
        createSequelPlotOutlineCallCount += 1

        if let error = createSequelPlotOutlineError {
            throw error
        }

        return createSequelPlotOutlineReturnValue ?? originalStory
    }

    public func createChapterBreakdown(story originalStory: Story) async throws -> Story {
        createChapterBreakdownCalled = true
        createChapterBreakdownCalledWith = originalStory
        createChapterBreakdownCallCount += 1

        if let error = createChapterBreakdownError {
            throw error
        }

        return createChapterBreakdownReturnValue ?? originalStory
    }

    public func parseChapterSummaries(story originalStory: Story) async throws -> Story {
        parseChapterSummariesCalled = true
        parseChapterSummariesCalledWith = originalStory
        parseChapterSummariesCallCount += 1

        if let error = parseChapterSummariesError {
            throw error
        }

        return parseChapterSummariesReturnValue ?? originalStory
    }

    public func getStoryDetails(story originalStory: Story) async throws -> Story {
        getStoryDetailsCalled = true
        getStoryDetailsCalledWith = originalStory
        getStoryDetailsCallCount += 1

        if let error = getStoryDetailsError {
            throw error
        }

        return getStoryDetailsReturnValue ?? originalStory
    }

    public func getChapterTitle(story originalStory: Story) async throws -> Story {
        getChapterTitleCalled = true
        getChapterTitleCalledWith = originalStory
        getChapterTitleCallCount += 1

        if let error = getChapterTitleError {
            throw error
        }

        return getChapterTitleReturnValue ?? originalStory
    }

    public func createChapter(story originalStory: Story) async throws -> Story {
        createChapterCalled = true
        createChapterCalledWith = originalStory
        createChapterCallCount += 1

        if let error = createChapterError {
            throw error
        }

        return createChapterReturnValue ?? originalStory
    }

    public func generateParagraph(story originalStory: Story, sentenceCount _: Int) async throws -> Story {
        generateParagraphCalled = true
        generateParagraphCalledWith = originalStory
        generateParagraphCallCount += 1

        if let error = generateParagraphError {
            throw error
        }

        return generateParagraphReturnValue ?? originalStory
    }

    // MARK: - Helper Methods

    public func reset() {
        createStoryThemeCalled = false
        createStoryThemeCalledWith = nil
        createStoryThemeCallCount = 0

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

        createStoryThemeReturnValue = nil
        createStoryThemeError = nil

        createPlotOutlineReturnValue = nil
        createPlotOutlineError = nil

        createSequelPlotOutlineReturnValue = nil
        createSequelPlotOutlineError = nil

        createChapterBreakdownReturnValue = nil
        createChapterBreakdownError = nil

        parseChapterSummariesCalled = false
        parseChapterSummariesCalledWith = nil
        parseChapterSummariesCallCount = 0
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
        generateParagraphCallCount = 0
        generateParagraphReturnValue = nil
        generateParagraphError = nil
    }
}
