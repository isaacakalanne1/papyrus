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
    case .onCreatedChapter(let chapter):
        newState.chapter = chapter
    case .createChapter,
            .failedToCreateChapter:
        break
    }
    return newState
}
