//
//  ReaderAction.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import TextGeneration

enum ReaderAction: Sendable {
    case createStory
    case createChapter(Story)
    case onCreatedChapter(Story)
    case failedToCreateChapter
    
    case updateMainCharacter(String)
    case updateSetting(String)
}
