//
//  Chapter.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation

public struct Chapter: Codable, Equatable, Sendable {
    public var id: UUID
    public var title: String
    public var content: String
    
    public init(
        id: UUID = UUID(),
        title: String = "",
        content: String = ""
    ) {
        self.id = id
        self.title = title
        self.content = content
    }
    
    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
    }
}
