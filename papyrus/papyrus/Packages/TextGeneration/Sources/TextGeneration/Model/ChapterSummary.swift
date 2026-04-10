//
//  ChapterSummary.swift
//  TextGeneration
//

import Foundation

public struct ChapterSummary: Codable, Equatable, Sendable {
    public var chapterNumber: Int
    public var summary: String

    public init(
        chapterNumber: Int,
        summary: String
    ) {
        self.chapterNumber = chapterNumber
        self.summary = summary
    }
}
