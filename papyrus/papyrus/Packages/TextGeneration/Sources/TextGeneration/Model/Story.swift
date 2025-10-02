//
//  Story.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation

public struct Story: Codable, Equatable, Sendable, Identifiable {
    public var id: UUID
    public var mainCharacter: String
    public var setting: String
    var plotOutline: String
    var chaptersBreakdown: String
    public var chapterIndex: Int
    public var maxNumberOfChapters: Int
    public var scrollOffset: CGFloat
    public var prequelIds: [UUID]
    public var sequelIds: [UUID]
    
    public var title: String
    public var chapters: [Chapter]
    
    public init(
        id: UUID = UUID(),
        mainCharacter: String = "",
        setting: String = "",
        plotOutline: String = "",
        chaptersBreakdown: String = "",
        chapterIndex: Int = 0,
        maxNumberOfChapters: Int = 0,
        scrollOffset: CGFloat = 0,
        prequelIds: [UUID] = [],
        sequelIds: [UUID] = [],
        title: String = "",
        chapters: [Chapter] = []
    ) {
        self.id = id
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.plotOutline = plotOutline
        self.chaptersBreakdown = chaptersBreakdown
        self.chapterIndex = chapterIndex
        self.maxNumberOfChapters = maxNumberOfChapters
        self.scrollOffset = scrollOffset
        self.prequelIds = prequelIds
        self.sequelIds = sequelIds
        self.title = title
        self.chapters = chapters
    }
    
    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.mainCharacter = try container.decode(String.self, forKey: .mainCharacter)
        self.setting = try container.decode(String.self, forKey: .setting)
        self.plotOutline = try container.decode(String.self, forKey: .plotOutline)
        self.chaptersBreakdown = try container.decode(String.self, forKey: .chaptersBreakdown)
        self.chapterIndex = try container.decode(Int.self, forKey: .chapterIndex)
        self.maxNumberOfChapters = try container.decodeIfPresent(Int.self, forKey: .maxNumberOfChapters) ?? 0
        self.scrollOffset = try container.decodeIfPresent(CGFloat.self, forKey: .scrollOffset) ?? 0
        self.prequelIds = try container.decodeIfPresent([UUID].self, forKey: .prequelIds) ?? []
        self.sequelIds = try container.decodeIfPresent([UUID].self, forKey: .prequelIds) ?? []
        self.title = try container.decode(String.self, forKey: .title)
        self.chapters = try container.decode([Chapter].self, forKey: .chapters)
    }
}
