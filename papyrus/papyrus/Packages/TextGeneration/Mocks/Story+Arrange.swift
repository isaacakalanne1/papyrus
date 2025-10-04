//
//  Story+Arrange.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
@testable import TextGeneration

public extension Story {
    static var arrange: Story {
        arrange()
    }
    
    static func arrange(
        id: UUID = UUID(),
        mainCharacter: String = "Test Character",
        setting: String = "Test Setting",
        plotOutline: String = "Test plot outline",
        chaptersBreakdown: String = "Test chapters breakdown",
        chapterIndex: Int = 0,
        maxNumberOfChapters: Int = 5,
        scrollOffset: CGFloat = 0,
        prequelIds: [UUID] = [],
        sequelIds: [UUID] = [],
        title: String = "Test Story",
        chapters: [Chapter] = [.arrange]
    ) -> Story {
        .init(
            id: id,
            mainCharacter: mainCharacter,
            setting: setting,
            plotOutline: plotOutline,
            chaptersBreakdown: chaptersBreakdown,
            chapterIndex: chapterIndex,
            maxNumberOfChapters: maxNumberOfChapters,
            scrollOffset: scrollOffset,
            prequelIds: prequelIds,
            sequelIds: sequelIds,
            title: title,
            chapters: chapters
        )
    }
}