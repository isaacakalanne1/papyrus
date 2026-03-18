//
//  StoryPerspective.swift
//  TextGeneration
//

import Foundation

public enum StoryPerspective: String, Codable, Equatable, Sendable {
    case firstPerson
    case thirdPerson

    public var promptDescription: String {
        switch self {
        case .firstPerson: "First person (narrator is the protagonist, using 'I')"
        case .thirdPerson: "Third person (narrator observes from outside, using 'he/she/they')"
        }
    }
}
