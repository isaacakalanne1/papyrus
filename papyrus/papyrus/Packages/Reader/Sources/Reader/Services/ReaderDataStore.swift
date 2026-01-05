//
//  ReaderDataStore.swift
//  Reader
//
//  Created by Isaac Akalanne on 28/09/2025.
//

import Foundation
import TextGeneration

public protocol ReaderDataStoreProtocol {
    func saveStory(_ story: Story) async throws
    func loadStory(withId id: UUID) async throws -> Story?
    func getAllSavedStoryIds() async throws -> [UUID]
    func deleteStory(withId id: UUID) async throws
}

public class ReaderDataStore: ReaderDataStoreProtocol {

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var storiesDirectory: URL {
        documentsDirectory.appendingPathComponent("Stories", isDirectory: true)
    }
    
    private var storyIdsFileURL: URL {
        storiesDirectory.appendingPathComponent("story_ids.json")
    }
    
    public init() {
        createStoriesDirectoryIfNeeded()
    }
    
    private func createStoriesDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: storiesDirectory.path) {
            try? fileManager.createDirectory(at: storiesDirectory, withIntermediateDirectories: true)
        }
    }
    
    private func storyFileURL(for id: UUID) -> URL {
        storiesDirectory.appendingPathComponent("\(id.uuidString).json")
    }
    
    public func saveStory(_ story: Story) async throws {
        let storyData = try encoder.encode(story)
        let storyURL = storyFileURL(for: story.id)
        
        try storyData.write(to: storyURL)
        
        var savedIds = try await getAllSavedStoryIds()
        if !savedIds.contains(story.id) {
            savedIds.append(story.id)
            let idsData = try encoder.encode(savedIds)
            try idsData.write(to: storyIdsFileURL)
        }
    }
    
    public func loadStory(withId id: UUID) async throws -> Story? {
        let storyURL = storyFileURL(for: id)
        
        guard fileManager.fileExists(atPath: storyURL.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: storyURL)
        return try decoder.decode(Story.self, from: data)
    }
    
    public func getAllSavedStoryIds() async throws -> [UUID] {
        guard fileManager.fileExists(atPath: storyIdsFileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: storyIdsFileURL)
        return try decoder.decode([UUID].self, from: data)
    }
    
    public func deleteStory(withId id: UUID) async throws {
        let storyURL = storyFileURL(for: id)
        
        if fileManager.fileExists(atPath: storyURL.path) {
            try fileManager.removeItem(at: storyURL)
        }
        
        var savedIds = try await getAllSavedStoryIds()
        savedIds.removeAll { $0 == id }
        
        let idsData = try encoder.encode(savedIds)
        try idsData.write(to: storyIdsFileURL)
    }
}
