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
    
    var hasStory: Bool {
        if case .story = self { return true }
        return false
    }
}
