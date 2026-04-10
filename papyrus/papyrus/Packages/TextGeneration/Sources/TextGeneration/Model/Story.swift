//
//  Story.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import Settings

public struct Story: Codable, Equatable, Sendable, Identifiable {
    public var id: UUID
    public var mainCharacter: String
    public var setting: String
    var themeDescription: String
    var plotOutline: String
    var chaptersBreakdown: String
    public var chapterSummaries: [ChapterSummary]
    public var chapterIndex: Int
    public var maxNumberOfChapters: Int
    public var scrollOffset: CGFloat
    public var prequelIds: [UUID]
    public var sequelIds: [UUID]

    public var title: String
    public var chapters: [Chapter]
    public var perspective: StoryPerspective
    public var mode: StoryMode

    public init(
        id: UUID = UUID(),
        mainCharacter: String = "",
        setting: String = "",
        themeDescription: String = "",
        plotOutline: String = "",
        chaptersBreakdown: String = "",
        chapterSummaries: [ChapterSummary] = [],
        chapterIndex: Int = 0,
        maxNumberOfChapters: Int = 0,
        scrollOffset: CGFloat = 0,
        prequelIds: [UUID] = [],
        sequelIds: [UUID] = [],
        title: String = "",
        chapters: [Chapter] = [],
        perspective: StoryPerspective = .thirdPerson,
        mode: StoryMode = .story
    ) {
        self.id = id
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.themeDescription = themeDescription
        self.plotOutline = plotOutline
        self.chaptersBreakdown = chaptersBreakdown
        self.chapterSummaries = chapterSummaries
        self.chapterIndex = chapterIndex
        self.maxNumberOfChapters = maxNumberOfChapters
        self.scrollOffset = scrollOffset
        self.prequelIds = prequelIds
        self.sequelIds = sequelIds
        self.title = title
        self.chapters = chapters
        self.perspective = perspective
        self.mode = mode
    }

    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        mainCharacter = try container.decode(String.self, forKey: .mainCharacter)
        setting = try container.decode(String.self, forKey: .setting)
        themeDescription = try container.decodeIfPresent(String.self, forKey: .themeDescription) ?? ""
        plotOutline = try container.decode(String.self, forKey: .plotOutline)
        chaptersBreakdown = try container.decode(String.self, forKey: .chaptersBreakdown)
        chapterSummaries = try container.decodeIfPresent([ChapterSummary].self, forKey: .chapterSummaries) ?? []
        chapterIndex = try container.decode(Int.self, forKey: .chapterIndex)
        maxNumberOfChapters = try container.decodeIfPresent(Int.self, forKey: .maxNumberOfChapters) ?? 0
        scrollOffset = try container.decodeIfPresent(CGFloat.self, forKey: .scrollOffset) ?? 0
        prequelIds = try container.decodeIfPresent([UUID].self, forKey: .prequelIds) ?? []
        sequelIds = try container.decodeIfPresent([UUID].self, forKey: .sequelIds) ?? []
        title = try container.decode(String.self, forKey: .title)
        chapters = try container.decode([Chapter].self, forKey: .chapters)
        perspective = try container.decodeIfPresent(StoryPerspective.self, forKey: .perspective) ?? .thirdPerson
        mode = try container.decodeIfPresent(StoryMode.self, forKey: .mode) ?? .story
    }
}
