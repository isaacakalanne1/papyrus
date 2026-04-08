//
//  Chapter.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation

// MARK: - ChapterAction

public enum ChapterAction: Equatable, Sendable {
    case next(String)

    public var promptDescription: String {
        switch self {
        case let .next(text):
            return "This is what the user specifies happens next: \(text)"
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
        let value = try container.decode(String.self, forKey: .value)
        self = .next(value)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .next(value):
            try container.encode("next", forKey: .type)
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
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        action = try container.decodeIfPresent(ChapterAction.self, forKey: .action)
    }
}
