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
    }
    return newState
}
