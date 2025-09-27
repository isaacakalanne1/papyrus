//
//  Story.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

public struct Story: Codable, Equatable {
    var mainCharacter: String
    var setting: String
    var chapterIndex: Int
    var chapters: [Chapter]
    
    public init(
        mainCharacter: String = "",
        setting: String = "",
        chapterIndex: Int = 0,
        chapters: [Chapter] = []
    ) {
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.chapterIndex = chapterIndex
        self.chapters = chapters
    }
    
    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mainCharacter = try container.decode(String.self, forKey: .mainCharacter)
        self.setting = try container.decode(String.self, forKey: .setting)
        self.chapterIndex = try container.decode(Int.self, forKey: .chapterIndex)
        self.chapters = try container.decode([Chapter].self, forKey: .chapters)
    }
}
