//
//  ChapterPreviewTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 20/03/2026.
//

import Testing
import Foundation
@testable import TextGeneration

class ChapterPreviewTests {

    // MARK: - firstLine Tests

    @Test
    func firstLine_normalContent_returnsFirstLine() {
        let chapter = Chapter(content: "It was a dark and stormy night.\nThe rain fell heavily.")

        #expect(chapter.firstLine == "It was a dark and stormy night.")
    }

    @Test
    func firstLine_leadingBlankLines_skipsToFirstNonBlank() {
        let chapter = Chapter(content: "\n\nThe hero stepped forward.\nAnd the crowd cheered.")

        #expect(chapter.firstLine == "The hero stepped forward.")
    }

    @Test
    func firstLine_whitespaceOnlyContent_returnsFallback() {
        let chapter = Chapter(content: "   \n  \n\t")

        #expect(chapter.firstLine == "...")
    }

    @Test
    func firstLine_emptyString_returnsFallback() {
        let chapter = Chapter(content: "")

        #expect(chapter.firstLine == "...")
    }

    @Test
    func firstLine_singleLineWithNoNewline_returnsThatLine() {
        let chapter = Chapter(content: "A lone sentence with no newline")

        #expect(chapter.firstLine == "A lone sentence with no newline")
    }

    @Test
    func firstLine_veryLongFirstLine_returnsFullLine() {
        let longLine = String(repeating: "A", count: 1000)
        let chapter = Chapter(content: "\(longLine)\nSecond line")

        #expect(chapter.firstLine == longLine)
    }
}
