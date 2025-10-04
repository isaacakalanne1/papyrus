//
//  ReaderAction.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import TextGeneration
import Settings

enum ReaderAction: Equatable, Sendable {
    case createStory
    case createSequel
    case createChapter(Story)
    case beginCreateStory
    case beginCreateSequel
    case beginCreateChapter(Story)
    case createPlotOutline(Story)
    case onCreatedPlotOutline(Story)
    case createChapterBreakdown(Story)
    case onCreatedChapterBreakdown(Story)
    case getStoryDetails(Story)
    case onGetStoryDetails(Story)
    case getChapterTitle(Story)
    case onGetChapterTitle(Story)
    case onCreatedChapter(Story)
    case failedToCreateChapter
    
    case loadAllStories
    case onLoadedStories([Story])
    case failedToLoadStories
    case setStory(Story?)
    case deleteStory(UUID)
    case onDeletedStory(UUID)
    
    case updateMainCharacter(String)
    case updateSetting(String)
    case updateChapterIndex(Story, Int)
    case updateScrollOffset(CGFloat)
    case saveStory(Story)
    case refreshSettings(SettingsState)
    case setShowStoryForm(Bool)
    case setShowSubscriptionSheet(Bool)
    case loadSubscriptions
}
