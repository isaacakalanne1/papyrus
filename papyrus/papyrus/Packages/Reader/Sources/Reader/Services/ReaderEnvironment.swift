//
//  ReaderEnvironment.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import TextGeneration
import Settings
import Subscription

public protocol ReaderEnvironmentProtocol {
    func createStoryTheme(story: Story) async throws -> Story
    func createPlotOutline(story: Story) async throws -> Story
    func createSequelPlotOutline(story: Story, previousStory: Story) async throws -> Story
    func createChapterBreakdown(story: Story) async throws -> Story
    func getStoryDetails(story: Story) async throws -> Story
    func getChapterTitle(story: Story) async throws -> Story
    func createChapter(story: Story) async throws -> Story
    func saveStory(_ story: Story) async throws
    func loadStory(withId id: UUID) async throws -> Story?
    func getAllSavedStoryIds() async throws -> [UUID]
    func deleteStory(withId id: UUID) async throws
    func loadAllStories() async throws -> [Story]
    func loadSubscriptions() async
    var settingsEnvironment: SettingsEnvironmentProtocol { get }
    var subscriptionEnvironment: SubscriptionEnvironmentProtocol { get }
}

public struct ReaderEnvironment: ReaderEnvironmentProtocol {
    private let textGenerationEnvironment: TextGenerationEnvironmentProtocol
    private let dataStore: ReaderDataStoreProtocol
    public let settingsEnvironment: SettingsEnvironmentProtocol
    public let subscriptionEnvironment: SubscriptionEnvironmentProtocol
    
    public init(
        dataStore: ReaderDataStoreProtocol = ReaderDataStore(),
        textGenerationEnvironment: TextGenerationEnvironmentProtocol,
        settingsEnvironment: SettingsEnvironmentProtocol,
        subscriptionEnvironment: SubscriptionEnvironmentProtocol
    ) {
        self.textGenerationEnvironment = textGenerationEnvironment
        self.dataStore = dataStore
        self.settingsEnvironment = settingsEnvironment
        self.subscriptionEnvironment = subscriptionEnvironment
    }
    
    public func createStoryTheme(story: Story) async throws -> Story {
        try await textGenerationEnvironment.createStoryTheme(story: story)
    }
    
    public func createPlotOutline(story: Story) async throws -> Story {
        try await textGenerationEnvironment.createPlotOutline(story: story)
    }
    
    public func createSequelPlotOutline(story: Story, previousStory: Story) async throws -> Story {
        try await textGenerationEnvironment.createSequelPlotOutline(story: story, previousStory: previousStory)
    }
    
    public func createChapterBreakdown(story: Story) async throws -> Story {
        try await textGenerationEnvironment.createChapterBreakdown(story: story)
    }
    
    public func getStoryDetails(story: Story) async throws -> Story {
        try await textGenerationEnvironment.getStoryDetails(story: story)
    }
    
    public func getChapterTitle(story: Story) async throws -> Story {
        try await textGenerationEnvironment.getChapterTitle(story: story)
    }
    
    public func createChapter(story: Story) async throws -> Story {
        try await textGenerationEnvironment.createChapter(story: story)
    }
    
    public func saveStory(_ story: Story) async throws {
        try await dataStore.saveStory(story)
    }
    
    public func loadStory(withId id: UUID) async throws -> Story? {
        try await dataStore.loadStory(withId: id)
    }
    
    public func getAllSavedStoryIds() async throws -> [UUID] {
        try await dataStore.getAllSavedStoryIds()
    }
    
    public func deleteStory(withId id: UUID) async throws {
        try await dataStore.deleteStory(withId: id)
    }
    
    public func loadAllStories() async throws -> [Story] {
        let storyIds = try await dataStore.getAllSavedStoryIds()
        var stories: [Story] = []
        
        for id in storyIds {
            if let story = try await dataStore.loadStory(withId: id) {
                stories.append(story)
            }
        }
        
        return stories
    }
    
    public func loadSubscriptions() async {
        await subscriptionEnvironment.loadSubscriptionOnInit()
    }
    
}
