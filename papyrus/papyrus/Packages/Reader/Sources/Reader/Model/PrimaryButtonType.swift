//
//  PrimaryButtonType.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation

enum PrimaryButtonType {
    case newStory
    case nextChapter
    case createSequel
    case createStory
    
    var title: String {
        switch self {
        case .newStory: return "New Story"
        case .nextChapter: return "Next Chapter"
        case .createSequel: return "Create Sequel"
        case .createStory: return "Create Story"
        }
    }
    
    var icon: String {
        switch self {
        case .newStory: return "plus.circle.fill"
        case .nextChapter: return "book.pages"
        case .createSequel: return "book.closed"
        case .createStory: return "pencil.and.ruler"
        }
    }
}