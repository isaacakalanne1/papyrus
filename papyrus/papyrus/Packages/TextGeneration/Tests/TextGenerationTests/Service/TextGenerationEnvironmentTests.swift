//
//  TextGenerationEnvironmentTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
@testable import TextGeneration
@testable import TextGenerationMocks

@MainActor
class TextGenerationEnvironmentTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization_withDefaultRepository() {
        let _ = TextGenerationEnvironment()
        
        // Test passes if initialization succeeds without error
        #expect(true)
    }
    
    @Test
    func initialization_withCustomRepository() {
        let mockRepository = MockTextGenerationRepository()
        let _ = TextGenerationEnvironment(repository: mockRepository)
        
        // Test passes if initialization succeeds without error
        #expect(true)
    }
    
    // MARK: - CreatePlotOutline Tests
    
    @Test
    func createPlotOutline_success_callsRepositoryAndReturnsResult() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(mainCharacter: "Hero", setting: "Fantasy World")
        let expectedStory = Story(
            mainCharacter: "Hero",
            setting: "Fantasy World",
            plotOutline: "Epic fantasy adventure plot"
        )
        mockRepository.createPlotOutlineReturnValue = expectedStory
        
        let result = try await environment.createPlotOutline(story: inputStory)
        
        #expect(mockRepository.createPlotOutlineCalled)
        #expect(mockRepository.createPlotOutlineCalledWith?.id == inputStory.id)
        #expect(result.plotOutline == "Epic fantasy adventure plot")
    }
    
    @Test
    func createPlotOutline_failure_throwsRepositoryError() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(mainCharacter: "Hero", setting: "Fantasy World")
        let expectedError = TextGenerationTestError("Plot outline failed")
        mockRepository.createPlotOutlineError = expectedError
        
        do {
            _ = try await environment.createPlotOutline(story: inputStory)
            #expect(false, "Expected error to be thrown")
        } catch {
            #expect(error is TextGenerationTestError)
        }
        
        #expect(mockRepository.createPlotOutlineCalled)
        #expect(mockRepository.createPlotOutlineCalledWith?.id == inputStory.id)
    }
    
    // MARK: - CreateSequelPlotOutline Tests
    
    @Test
    func createSequelPlotOutline_success_callsRepositoryAndReturnsResult() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(mainCharacter: "Hero", setting: "New World")
        let previousStory = Story(mainCharacter: "Hero", setting: "Old World")
        let expectedStory = Story(
            mainCharacter: "Hero",
            setting: "New World",
            plotOutline: "Sequel adventure plot"
        )
        mockRepository.createSequelPlotOutlineReturnValue = expectedStory
        
        let result = try await environment.createSequelPlotOutline(story: inputStory, previousStory: previousStory)
        
        #expect(mockRepository.createSequelPlotOutlineCalled)
        #expect(mockRepository.createSequelPlotOutlineCalledWith?.story.id == inputStory.id)
        #expect(mockRepository.createSequelPlotOutlineCalledWith?.previousStory.id == previousStory.id)
        #expect(result.plotOutline == "Sequel adventure plot")
    }
    
    @Test
    func createSequelPlotOutline_failure_throwsRepositoryError() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(mainCharacter: "Hero", setting: "New World")
        let previousStory = Story(mainCharacter: "Hero", setting: "Old World")
        let expectedError = TextGenerationTestError("Sequel plot outline failed")
        mockRepository.createSequelPlotOutlineError = expectedError
        
        do {
            _ = try await environment.createSequelPlotOutline(story: inputStory, previousStory: previousStory)
            #expect(false, "Expected error to be thrown")
        } catch {
            #expect(error is TextGenerationTestError)
        }
        
        #expect(mockRepository.createSequelPlotOutlineCalled)
    }
    
    // MARK: - CreateChapterBreakdown Tests
    
    @Test
    func createChapterBreakdown_success_callsRepositoryAndReturnsResult() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(plotOutline: "Epic adventure plot")
        let expectedStory = Story(
            plotOutline: "Epic adventure plot",
            chaptersBreakdown: "Chapter 1: Beginning\nChapter 2: Middle\nChapter 3: End"
        )
        mockRepository.createChapterBreakdownReturnValue = expectedStory
        
        let result = try await environment.createChapterBreakdown(story: inputStory)
        
        #expect(mockRepository.createChapterBreakdownCalled)
        #expect(mockRepository.createChapterBreakdownCalledWith?.id == inputStory.id)
        #expect(result.chaptersBreakdown == "Chapter 1: Beginning\nChapter 2: Middle\nChapter 3: End")
    }
    
    @Test
    func createChapterBreakdown_failure_throwsRepositoryError() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(plotOutline: "Epic adventure plot")
        let expectedError = TextGenerationTestError("Chapter breakdown failed")
        mockRepository.createChapterBreakdownError = expectedError
        
        do {
            _ = try await environment.createChapterBreakdown(story: inputStory)
            #expect(false, "Expected error to be thrown")
        } catch {
            #expect(error is TextGenerationTestError)
        }
        
        #expect(mockRepository.createChapterBreakdownCalled)
    }
    
    // MARK: - GetStoryDetails Tests
    
    @Test
    func getStoryDetails_success_callsRepositoryAndReturnsResult() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(chaptersBreakdown: "Chapter breakdown text")
        let expectedStory = Story(
            chaptersBreakdown: "Chapter breakdown text",
            maxNumberOfChapters: 15
        )
        mockRepository.getStoryDetailsReturnValue = expectedStory
        
        let result = try await environment.getStoryDetails(story: inputStory)
        
        #expect(mockRepository.getStoryDetailsCalled)
        #expect(mockRepository.getStoryDetailsCalledWith?.id == inputStory.id)
        #expect(result.maxNumberOfChapters == 15)
    }
    
    @Test
    func getStoryDetails_failure_throwsRepositoryError() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(chaptersBreakdown: "Chapter breakdown text")
        let expectedError = TextGenerationTestError("Story details failed")
        mockRepository.getStoryDetailsError = expectedError
        
        do {
            _ = try await environment.getStoryDetails(story: inputStory)
            #expect(false, "Expected error to be thrown")
        } catch {
            #expect(error is TextGenerationTestError)
        }
        
        #expect(mockRepository.getStoryDetailsCalled)
    }
    
    // MARK: - GetChapterTitle Tests
    
    @Test
    func getChapterTitle_success_callsRepositoryAndReturnsResult() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(plotOutline: "Adventure story plot")
        let expectedStory = Story(
            plotOutline: "Adventure story plot",
            title: "The Great Adventure"
        )
        mockRepository.getChapterTitleReturnValue = expectedStory
        
        let result = try await environment.getChapterTitle(story: inputStory)
        
        #expect(mockRepository.getChapterTitleCalled)
        #expect(mockRepository.getChapterTitleCalledWith?.id == inputStory.id)
        #expect(result.title == "The Great Adventure")
    }
    
    @Test
    func getChapterTitle_failure_throwsRepositoryError() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story(plotOutline: "Adventure story plot")
        let expectedError = TextGenerationTestError("Chapter title failed")
        mockRepository.getChapterTitleError = expectedError
        
        do {
            _ = try await environment.getChapterTitle(story: inputStory)
            #expect(false, "Expected error to be thrown")
        } catch {
            #expect(error is TextGenerationTestError)
        }
        
        #expect(mockRepository.getChapterTitleCalled)
    }
    
    // MARK: - CreateChapter Tests
    
    @Test
    func createChapter_success_callsRepositoryAndReturnsResult() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let existingChapter = Chapter(title: "Chapter 1", content: "First chapter content")
        let inputStory = Story(chapters: [existingChapter])
        let newChapter = Chapter(title: "Chapter 2", content: "Second chapter content")
        let expectedStory = Story(chapters: [existingChapter, newChapter])
        mockRepository.createChapterReturnValue = expectedStory
        
        let result = try await environment.createChapter(story: inputStory)
        
        #expect(mockRepository.createChapterCalled)
        #expect(mockRepository.createChapterCalledWith?.id == inputStory.id)
        #expect(result.chapters.count == 2)
        #expect(result.chapters[1].title == "Chapter 2")
    }
    
    @Test
    func createChapter_failure_throwsRepositoryError() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let inputStory = Story()
        let expectedError = TextGenerationTestError("Chapter creation failed")
        mockRepository.createChapterError = expectedError
        
        do {
            _ = try await environment.createChapter(story: inputStory)
            #expect(false, "Expected error to be thrown")
        } catch {
            #expect(error is TextGenerationTestError)
        }
        
        #expect(mockRepository.createChapterCalled)
    }
    
    // MARK: - Integration Tests
    
    @Test
    func allMethods_trackCallCounts() async throws {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let story = Story(mainCharacter: "Hero", setting: "World")
        let previousStory = Story(mainCharacter: "Old Hero", setting: "Old World")
        
        // Configure return values to avoid errors
        mockRepository.createPlotOutlineReturnValue = story
        mockRepository.createSequelPlotOutlineReturnValue = story
        mockRepository.createChapterBreakdownReturnValue = story
        mockRepository.getStoryDetailsReturnValue = story
        mockRepository.getChapterTitleReturnValue = story
        mockRepository.createChapterReturnValue = story
        
        // Call each method multiple times
        _ = try await environment.createPlotOutline(story: story)
        _ = try await environment.createPlotOutline(story: story)
        
        _ = try await environment.createSequelPlotOutline(story: story, previousStory: previousStory)
        
        _ = try await environment.createChapterBreakdown(story: story)
        _ = try await environment.createChapterBreakdown(story: story)
        _ = try await environment.createChapterBreakdown(story: story)
        
        _ = try await environment.getStoryDetails(story: story)
        
        _ = try await environment.getChapterTitle(story: story)
        _ = try await environment.getChapterTitle(story: story)
        _ = try await environment.getChapterTitle(story: story)
        _ = try await environment.getChapterTitle(story: story)
        
        _ = try await environment.createChapter(story: story)
        
        // Verify call counts
        #expect(mockRepository.createPlotOutlineCallCount == 2)
        #expect(mockRepository.createSequelPlotOutlineCallCount == 1)
        #expect(mockRepository.createChapterBreakdownCallCount == 3)
        #expect(mockRepository.getStoryDetailsCallCount == 1)
        #expect(mockRepository.getChapterTitleCallCount == 4)
        #expect(mockRepository.createChapterCallCount == 1)
    }
    
    @Test
    func mockRepository_reset_clearsAllState() async {
        let mockRepository = MockTextGenerationRepository()
        let environment = TextGenerationEnvironment(repository: mockRepository)
        
        let story = Story()
        
        // Configure and call methods
        mockRepository.createPlotOutlineReturnValue = story
        mockRepository.createPlotOutlineError = TextGenerationTestError("Test error")
        _ = try? await environment.createPlotOutline(story: story)
        
        // Verify state before reset
        #expect(mockRepository.createPlotOutlineCalled == true)
        #expect(mockRepository.createPlotOutlineCallCount == 1)
        #expect(mockRepository.createPlotOutlineReturnValue != nil)
        #expect(mockRepository.createPlotOutlineError != nil)
        
        // Reset and verify clean state
        mockRepository.reset()
        
        #expect(mockRepository.createPlotOutlineCalled == false)
        #expect(mockRepository.createPlotOutlineCallCount == 0)
        #expect(mockRepository.createPlotOutlineCalledWith == nil)
        #expect(mockRepository.createPlotOutlineReturnValue == nil)
        #expect(mockRepository.createPlotOutlineError == nil)
    }
}
