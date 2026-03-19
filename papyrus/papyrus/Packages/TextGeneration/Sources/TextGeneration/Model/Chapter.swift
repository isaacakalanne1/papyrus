//
//  Chapter.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation

// MARK: - ChapterAction

public enum ChapterAction: Equatable, Sendable {
    case `do`(String)
    case say(String)
    case event(String)

    public var promptDescription: String {
        switch self {
        case .do(let text):
            return "The user has specified this action: \(text)"
        case .say(let text):
            return "The user's character says: \"\(text)\""
        case .event(let text):
            return "The following event occurs in the story: \(text)"
        }
    }
}

extension ChapterAction: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let value = try container.decode(String.self, forKey: .value)
        switch type {
        case "do":
            self = .do(value)
        case "say":
            self = .say(value)
        case "event":
            self = .event(value)
        default:
            self = .do(value)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .do(let value):
            try container.encode("do", forKey: .type)
            try container.encode(value, forKey: .value)
        case .say(let value):
            try container.encode("say", forKey: .type)
            try container.encode(value, forKey: .value)
        case .event(let value):
            try container.encode("event", forKey: .type)
            try container.encode(value, forKey: .value)
        }
    }
}

// MARK: - Chapter

public struct Chapter: Codable, Equatable, Sendable {
    public var id: UUID
    public var content: String
    public var action: ChapterAction?

    public init(
        id: UUID = UUID(),
        content: String = "",
        action: ChapterAction? = nil
    ) {
        self.id = id
        self.content = content
        self.action = action
    }

    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
        self.action = try container.decodeIfPresent(ChapterAction.self, forKey: .action)
    }
}
