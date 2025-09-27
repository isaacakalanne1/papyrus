//
//  Chapter.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

public struct Chapter: Codable, Equatable, Sendable {
    public var content: String
    
    public init(
        content: String = ""
    ) {
        self.content = content
    }
    
    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
    }
}
