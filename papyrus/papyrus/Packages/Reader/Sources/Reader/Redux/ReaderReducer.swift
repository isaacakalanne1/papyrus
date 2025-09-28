//
//  ReaderReducer.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import ReduxKit

@MainActor
let readerReducer: Reducer<ReaderState, ReaderAction> = { state, action in
    var newState = state
    switch action {
    case .createStory:
        newState.isLoading = true
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting
        )
    case .onCreatedChapter(let story):
        newState.story = story
        newState.isLoading = false
    case .updateMainCharacter(let mainCharacter):
        newState.mainCharacter = mainCharacter
    case .updateSetting(let setting):
        newState.setting = setting
    case .createChapter:
        newState.isLoading = true
    case .failedToCreateChapter:
        newState.isLoading = false
    case .loadAllStories:
        newState.isLoading = true
    case .onLoadedStories(let stories):
        newState.loadedStories = stories
        newState.isLoading = false
    case .failedToLoadStories:
        newState.isLoading = false
    case .setStory(let story):
        newState.story = story
    case .updateChapterIndex(let index):
        if var story = newState.story {
            story.chapterIndex = max(0, min(index, story.chapters.count - 1))
            newState.story = story
        }
    }
    return newState
}
