//
//  ReaderMiddlewareTests.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import Foundation
import TextGeneration
import Settings
import SettingsMocks
@testable import Reader
@testable import ReaderMocks

@MainActor
class ReaderMiddlewareTests {
    
    // MARK: - Story Creation Tests
    
    @Test
    func createStory_canCreate_returnsBeginCreateStory() async {
        let state = ReaderState(
            story: Story(title: "Test Story"),
            settingsState: SettingsState(isSubscribed: true)
        )
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .createStory, environment)
        
        #expect(result == .beginCreateStory)
    }
    
    @Test
    func createStory_cannotCreate_returnsSetShowSubscriptionSheet() async {
        let state = ReaderState(
            story: Story(chapters: [
                Chapter(content: ""),
                Chapter(content: "")
            ]),
            settingsState: SettingsState(isSubscribed: false)
        )
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .createStory, environment)
        
        #expect(result == .setShowSubscriptionSheet(true))
    }
    
    @Test
    func createSequel_canCreate_returnsBeginCreateSequel() async {
        let state = ReaderState(
            story: Story(title: "Test Story"),
            settingsState: SettingsState(isSubscribed: true)
        )
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .createSequel, environment)
        
        #expect(result == .beginCreateSequel)
    }
    
    @Test
    func createSequel_cannotCreate_returnsSetShowSubscriptionSheet() async {
        let state = ReaderState(
            story: Story(chapters: [
                Chapter(content: ""),
                Chapter(content: "")
            ]),
            settingsState: SettingsState(isSubscribed: false)
        )
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .createSequel, environment)
        
        #expect(result == .setShowSubscriptionSheet(true))
    }
    
    // MARK: - Plot Outline Tests
    
    @Test
    func createPlotOutline_success_returnsOnCreatedPlotOutline() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        let outputStory = Story(plotOutline: "Test plot", title: "Output Story")
        environment.createPlotOutlineReturnValue = outputStory
        
        let result = await readerMiddleware(state, .createPlotOutline(inputStory), environment)
        
        #expect(environment.createPlotOutlineCalled)
        #expect(environment.createPlotOutlineCalledWith?.id == inputStory.id)
        #expect(result == .onCreatedPlotOutline(outputStory))
    }
    
    @Test
    func createPlotOutline_failure_returnsFailedToCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        environment.createPlotOutlineError = ReaderTestError("Plot outline failed")
        
        let result = await readerMiddleware(state, .createPlotOutline(inputStory), environment)
        
        #expect(environment.createPlotOutlineCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    @Test
    func onCreatedPlotOutline_returnsCreateChapterBreakdown() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(title: "Test Story")
        
        let result = await readerMiddleware(state, .onCreatedPlotOutline(story), environment)
        
        #expect(result == .createChapterBreakdown(story))
    }
    
    // MARK: - Chapter Breakdown Tests
    
    @Test
    func createChapterBreakdown_success_returnsOnCreatedChapterBreakdown() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        let outputStory = Story(chaptersBreakdown: "Test breakdown", title: "Output Story")
        environment.createChapterBreakdownReturnValue = outputStory
        
        let result = await readerMiddleware(state, .createChapterBreakdown(inputStory), environment)
        
        #expect(environment.createChapterBreakdownCalled)
        #expect(environment.createChapterBreakdownCalledWith?.id == inputStory.id)
        #expect(result == .onCreatedChapterBreakdown(outputStory))
    }
    
    @Test
    func createChapterBreakdown_failure_returnsFailedToCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        environment.createChapterBreakdownError = ReaderTestError("Breakdown failed")
        
        let result = await readerMiddleware(state, .createChapterBreakdown(inputStory), environment)
        
        #expect(environment.createChapterBreakdownCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    @Test
    func onCreatedChapterBreakdown_withChapters_returnsBeginCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(maxNumberOfChapters: 5, title: "Test Story")
        
        let result = await readerMiddleware(state, .onCreatedChapterBreakdown(story), environment)
        
        #expect(result == .beginCreateChapter(story))
    }
    
    @Test
    func onCreatedChapterBreakdown_noChapters_returnsGetStoryDetails() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(maxNumberOfChapters: 0, title: "Test Story")
        
        let result = await readerMiddleware(state, .onCreatedChapterBreakdown(story), environment)
        
        #expect(result == .getStoryDetails(story))
    }
    
    // MARK: - Story Details Tests
    
    @Test
    func getStoryDetails_success_returnsOnGetStoryDetails() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        let outputStory = Story(setting: "Test details", title: "Output Story")
        environment.getStoryDetailsReturnValue = outputStory
        
        let result = await readerMiddleware(state, .getStoryDetails(inputStory), environment)
        
        #expect(environment.getStoryDetailsCalled)
        #expect(environment.getStoryDetailsCalledWith?.id == inputStory.id)
        #expect(result == .onGetStoryDetails(outputStory))
    }
    
    @Test
    func getStoryDetails_failure_returnsFailedToCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        environment.getStoryDetailsError = ReaderTestError("Details failed")
        
        let result = await readerMiddleware(state, .getStoryDetails(inputStory), environment)
        
        #expect(environment.getStoryDetailsCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    @Test
    func onGetStoryDetails_returnsGetChapterTitle() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(title: "Test Story")
        
        let result = await readerMiddleware(state, .onGetStoryDetails(story), environment)
        
        #expect(result == .getChapterTitle(story))
    }
    
    // MARK: - Chapter Title Tests
    
    @Test
    func getChapterTitle_success_returnsOnGetChapterTitle() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        let outputStory = Story(title: "Output Story", chapters: [
            Chapter(content: "")
        ])
        environment.getChapterTitleReturnValue = outputStory
        
        let result = await readerMiddleware(state, .getChapterTitle(inputStory), environment)
        
        #expect(environment.getChapterTitleCalled)
        #expect(environment.getChapterTitleCalledWith?.id == inputStory.id)
        #expect(result == .onGetChapterTitle(outputStory))
    }
    
    @Test
    func getChapterTitle_failure_returnsFailedToCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        environment.getChapterTitleError = ReaderTestError("Title failed")
        
        let result = await readerMiddleware(state, .getChapterTitle(inputStory), environment)
        
        #expect(environment.getChapterTitleCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    @Test
    func onGetChapterTitle_returnsBeginCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(title: "Test Story")
        
        let result = await readerMiddleware(state, .onGetChapterTitle(story), environment)
        
        #expect(result == .beginCreateChapter(story))
    }
    
    // MARK: - Create Chapter Tests
    
    @Test
    func createChapter_canCreate_returnsBeginCreateChapter() async {
        let state = ReaderState(
            story: Story(title: "Test Story"),
            settingsState: SettingsState(isSubscribed: true)
        )
        let environment = MockReaderEnvironment()
        let story = Story(title: "Chapter Story")
        
        let result = await readerMiddleware(state, .createChapter(story), environment)
        
        #expect(result == .beginCreateChapter(story))
    }
    
    @Test
    func createChapter_cannotCreate_returnsSetShowSubscriptionSheet() async {
        let state = ReaderState(
            story: Story(chapters: [
                Chapter(content: ""),
                Chapter(content: "")
            ]),
            settingsState: SettingsState(isSubscribed: false)
        )
        let environment = MockReaderEnvironment()
        let story = Story(title: "Chapter Story")
        
        let result = await readerMiddleware(state, .createChapter(story), environment)
        
        #expect(result == .setShowSubscriptionSheet(true))
    }
    
    // MARK: - Story Management Tests
    
    @Test
    func loadAllStories_success_returnsOnLoadedStories() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let stories = [
            Story(title: "Story 1"),
            Story(title: "Story 2")
        ]
        environment.loadAllStoriesReturnValue = stories
        
        let result = await readerMiddleware(state, .loadAllStories, environment)
        
        #expect(environment.loadAllStoriesCalled)
        #expect(result == .onLoadedStories(stories))
    }
    
    @Test
    func loadAllStories_failure_returnsFailedToLoadStories() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        environment.loadAllStoriesError = ReaderTestError("Load failed")
        
        let result = await readerMiddleware(state, .loadAllStories, environment)
        
        #expect(environment.loadAllStoriesCalled)
        #expect(result == .failedToLoadStories)
    }
    
    @Test
    func deleteStory_success_returnsOnDeletedStory() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let storyId = UUID()
        
        let result = await readerMiddleware(state, .deleteStory(storyId), environment)
        
        #expect(environment.deleteStoryWithIdCalled)
        #expect(environment.deleteStoryWithIdCalledWith == storyId)
        #expect(result == .onDeletedStory(storyId))
    }
    
    @Test
    func deleteStory_failure_returnsFailedToLoadStories() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let storyId = UUID()
        environment.deleteStoryWithIdError = ReaderTestError("Delete failed")
        
        let result = await readerMiddleware(state, .deleteStory(storyId), environment)
        
        #expect(environment.deleteStoryWithIdCalled)
        #expect(result == .failedToLoadStories)
    }
    
    // MARK: - Chapter Creation and Navigation Tests
    
    @Test
    func onCreatedChapter_returnsUpdateChapterIndex() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(
            title: "Test Story",
            chapters: [
                Chapter(content: ""),
                Chapter(content: ""),
                Chapter(content: "")
            ]
        )
        
        let result = await readerMiddleware(state, .onCreatedChapter(story), environment)
        
        #expect(result == .updateChapterIndex(story, 2)) // Index of last chapter
    }
    
    @Test
    func updateChapterIndex_returnsSaveStory() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(title: "Test Story")
        
        let result = await readerMiddleware(state, .updateChapterIndex(story, 1), environment)
        
        #expect(result == .saveStory(story))
    }
    
    // MARK: - Save Story Tests
    
    @Test
    func saveStory_success_returnsNil() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(title: "Test Story")
        
        let result = await readerMiddleware(state, .saveStory(story), environment)
        
        #expect(environment.saveStoryCalled)
        #expect(environment.saveStoryCalledWith?.id == story.id)
        #expect(result == nil)
    }
    
    @Test
    func saveStory_withPrequelIds_savesPrequelStories() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        
        let prequelId1 = UUID()
        let prequelId2 = UUID()
        let story = Story(
            prequelIds: [prequelId1, prequelId2], title: "Test Story"
        )
        
        let prequel1 = Story(id: prequelId1, sequelIds: [], title: "Prequel 1")
        let prequel2 = Story(id: prequelId2, sequelIds: [story.id], title: "Prequel 2")
        
        environment.loadStoryWithIdReturnValue = nil
        
        let result = await readerMiddleware(state, .saveStory(story), environment)
        
        #expect(environment.saveStoryCalled)
        #expect(environment.saveStoryCallCount >= 1) // At least the main story
        #expect(environment.loadStoryWithIdCalled)
        #expect(result == nil)
    }
    
    @Test
    func saveStory_failure_returnsFailedToCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(title: "Test Story")
        environment.saveStoryError = ReaderTestError("Save failed")
        
        let result = await readerMiddleware(state, .saveStory(story), environment)
        
        #expect(environment.saveStoryCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    // MARK: - Scroll Offset Tests
    
    @Test
    func updateScrollOffset_withStory_savesStory() async {
        let story = Story(scrollOffset: 100.0, title: "Test Story")
        let state = ReaderState(story: story)
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .updateScrollOffset(0), environment)
        
        #expect(environment.saveStoryCalled)
        #expect(environment.saveStoryCalledWith?.id == story.id)
        #expect(result == nil)
    }
    
    @Test
    func updateScrollOffset_noStory_returnsNil() async {
        let state = ReaderState(story: nil)
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .updateScrollOffset(0), environment)
        
        #expect(!environment.saveStoryCalled)
        #expect(result == nil)
    }
    
    @Test
    func updateScrollOffset_saveFailure_returnsFailedToCreateChapter() async {
        let story = Story(title: "Test Story")
        let state = ReaderState(story: story)
        let environment = MockReaderEnvironment()
        environment.saveStoryError = ReaderTestError("Save failed")
        
        let result = await readerMiddleware(state, .updateScrollOffset(0), environment)
        
        #expect(environment.saveStoryCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    // MARK: - Subscription Tests
    
    @Test
    func loadSubscriptions_callsEnvironment() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .loadSubscriptions, environment)
        
        #expect(environment.loadSubscriptionsCalled)
        #expect(result == nil)
    }
    
    // MARK: - Begin Create Story Tests
    
    @Test
    func beginCreateStory_withStory_returnsCreatePlotOutline() async {
        let story = Story(title: "Test Story")
        let state = ReaderState(story: story)
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .beginCreateStory, environment)
        
        #expect(result == .createPlotOutline(story))
    }
    
    @Test
    func beginCreateStory_noStory_returnsFailedToCreateChapter() async {
        let state = ReaderState(story: nil)
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .beginCreateStory, environment)
        
        #expect(result == .failedToCreateChapter)
    }
    
    // MARK: - Begin Create Sequel Tests
    
    @Test
    func beginCreateSequel_withStories_callsCreateSequelPlotOutline() async {
        let currentStory = Story(title: "Current Story")
        let sequelStory = Story(title: "Sequel Story")
        let state = ReaderState(
            story: currentStory,
            sequelStory: sequelStory
        )
        let environment = MockReaderEnvironment()
        let outputStory = Story(title: "Output Sequel")
        environment.createSequelPlotOutlineReturnValue = outputStory
        
        let result = await readerMiddleware(state, .beginCreateSequel, environment)
        
        #expect(environment.saveStoryCalled)
        #expect(environment.saveStoryCalledWith?.id == currentStory.id)
        #expect(environment.createSequelPlotOutlineCalled)
        #expect(environment.createSequelPlotOutlineCalledWith?.story.id == sequelStory.id)
        #expect(environment.createSequelPlotOutlineCalledWith?.previousStory.id == currentStory.id)
        #expect(result == .onCreatedPlotOutline(outputStory))
    }
    
    @Test
    func beginCreateSequel_noCurrentStory_returnsFailedToCreateChapter() async {
        let state = ReaderState(
            story: nil,
            sequelStory: Story(title: "Sequel Story")
        )
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .beginCreateSequel, environment)
        
        #expect(result == .failedToCreateChapter)
    }
    
    @Test
    func beginCreateSequel_noSequelStory_returnsFailedToCreateChapter() async {
        let state = ReaderState(
            story: Story(title: "Current Story"),
            sequelStory: nil
        )
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .beginCreateSequel, environment)
        
        #expect(result == .failedToCreateChapter)
    }
    
    @Test
    func beginCreateSequel_saveFailure_returnsFailedToCreateChapter() async {
        let currentStory = Story(title: "Current Story")
        let sequelStory = Story(title: "Sequel Story")
        let state = ReaderState(
            story: currentStory,
            sequelStory: sequelStory
        )
        let environment = MockReaderEnvironment()
        environment.saveStoryError = ReaderTestError("Save failed")
        
        let result = await readerMiddleware(state, .beginCreateSequel, environment)
        
        #expect(environment.saveStoryCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    @Test
    func beginCreateSequel_createSequelFailure_returnsFailedToCreateChapter() async {
        let currentStory = Story(title: "Current Story")
        let sequelStory = Story(title: "Sequel Story")
        let state = ReaderState(
            story: currentStory,
            sequelStory: sequelStory
        )
        let environment = MockReaderEnvironment()
        environment.createSequelPlotOutlineError = ReaderTestError("Create sequel failed")
        
        let result = await readerMiddleware(state, .beginCreateSequel, environment)
        
        #expect(environment.createSequelPlotOutlineCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    // MARK: - Begin Create Chapter Tests
    
    @Test
    func beginCreateChapter_success_returnsOnCreatedChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        let outputStory = Story(
            title: "Output Story",
            chapters: [Chapter(content: "Content")]
        )
        environment.createChapterReturnValue = outputStory
        
        let result = await readerMiddleware(state, .beginCreateChapter(inputStory), environment)
        
        #expect(environment.createChapterCalled)
        #expect(environment.createChapterCalledWith?.id == inputStory.id)
        #expect(result == .onCreatedChapter(outputStory))
    }
    
    @Test
    func beginCreateChapter_failure_returnsFailedToCreateChapter() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let inputStory = Story(title: "Input Story")
        environment.createChapterError = ReaderTestError("Chapter creation failed")
        
        let result = await readerMiddleware(state, .beginCreateChapter(inputStory), environment)
        
        #expect(environment.createChapterCalled)
        #expect(result == .failedToCreateChapter)
    }
    
    // MARK: - Selected Story for Details Tests
    
    @Test
    func setSelectedStoryForDetails_withStory_returnsNil() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        let story = Story(title: "Test Story")
        
        let result = await readerMiddleware(state, .setSelectedStoryForDetails(story), environment)
        
        #expect(result == nil)
    }
    
    @Test
    func setSelectedStoryForDetails_withNil_returnsNil() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        
        let result = await readerMiddleware(state, .setSelectedStoryForDetails(nil), environment)
        
        #expect(result == nil)
    }
    
    // MARK: - No-op Actions Test
    
    @Test
    func noOpActions_returnNil() async {
        let state = ReaderState()
        let environment = MockReaderEnvironment()
        
        let noOpActions: [ReaderAction] = [
            .failedToCreateChapter,
            .updateSetting("Test Setting"),
            .updateMainCharacter("Test Character"),
            .onLoadedStories([]),
            .failedToLoadStories,
            .setStory(Story()),
            .onDeletedStory(UUID()),
            .refreshSettings(SettingsState()),
            .setShowStoryForm(true),
            .setShowSubscriptionSheet(true),
            .setSelectedStoryForDetails(Story())
        ]
        
        for action in noOpActions {
            let result = await readerMiddleware(state, action, environment)
            #expect(result == nil)
        }
    }
}
