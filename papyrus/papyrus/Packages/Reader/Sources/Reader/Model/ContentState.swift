//
//  ContentState.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import TextGeneration

public enum ContentState {
    case welcome
    case story(Story)
    case interactiveStory(Story)

    var hasStory: Bool {
        switch self {
        case .story, .interactiveStory: return true
        case .welcome: return false
        }
    }
}
