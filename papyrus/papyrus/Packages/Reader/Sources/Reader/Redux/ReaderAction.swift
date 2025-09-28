//
//  ReaderAction.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import TextGeneration

enum ReaderAction: Sendable {
    case createStory
    case createPlotOutline(Story)
    case onCreatedPlotOutline(Story)
    case createChapterBreakdown(Story)
    case onCreatedChapterBreakdown(Story)
    case getStoryDetails(Story)
    case onGetStoryDetails(Story)
    case createChapter(Story)
    case onCreatedChapter(Story)
    case failedToCreateChapter
    
    case loadAllStories
    case onLoadedStories([Story])
    case failedToLoadStories
    case setStory(Story)
    
    case updateMainCharacter(String)
    case updateSetting(String)
    case updateChapterIndex(Int)
}
