//
//  ChapterSummaryTests.swift
//  TextGeneration
//

import Foundation
import Testing
@testable import TextGeneration

class ChapterSummaryTests {
    // MARK: - Initialization Tests

    @Test
    func initialization_storesProperties() {
        let summary = ChapterSummary(chapterNumber: 3, summary: "The hero faces the dragon.")

        #expect(summary.chapterNumber == 3)
        #expect(summary.summary == "The hero faces the dragon.")
    }

    // MARK: - Equatable Tests

    @Test
    func equatable_equalValues_areEqual() {
        let lhs = ChapterSummary(chapterNumber: 1, summary: "Opening chapter")
        let rhs = ChapterSummary(chapterNumber: 1, summary: "Opening chapter")

        #expect(lhs == rhs)
    }

    @Test
    func equatable_differentChapterNumber_areNotEqual() {
        let lhs = ChapterSummary(chapterNumber: 1, summary: "Opening chapter")
        let rhs = ChapterSummary(chapterNumber: 2, summary: "Opening chapter")

        #expect(lhs != rhs)
    }

    @Test
    func equatable_differentSummary_areNotEqual() {
        let lhs = ChapterSummary(chapterNumber: 1, summary: "Opening chapter")
        let rhs = ChapterSummary(chapterNumber: 1, summary: "Closing chapter")

        #expect(lhs != rhs)
    }

    // MARK: - Codable Tests

    @Test
    func encode_producesExpectedJSON() throws {
        let summary = ChapterSummary(chapterNumber: 5, summary: "A twist is revealed.")

        let data = try JSONEncoder().encode(summary)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        #expect(json?["chapterNumber"] as? Int == 5)
        #expect(json?["summary"] as? String == "A twist is revealed.")
    }

    @Test
    func decode_fromValidJSON_producesCorrectModel() throws {
        let json = """
        {"chapterNumber": 7, "summary": "The climax arrives."}
        """
        let data = Data(json.utf8)

        let summary = try JSONDecoder().decode(ChapterSummary.self, from: data)

        #expect(summary.chapterNumber == 7)
        #expect(summary.summary == "The climax arrives.")
    }

    @Test
    func decode_array_fromValidJSON_producesCorrectModels() throws {
        let json = """
        [
          {"chapterNumber": 1, "summary": "The journey begins."},
          {"chapterNumber": 2, "summary": "The first obstacle."}
        ]
        """
        let data = Data(json.utf8)

        let summaries = try JSONDecoder().decode([ChapterSummary].self, from: data)

        #expect(summaries.count == 2)
        #expect(summaries[0].chapterNumber == 1)
        #expect(summaries[0].summary == "The journey begins.")
        #expect(summaries[1].chapterNumber == 2)
        #expect(summaries[1].summary == "The first obstacle.")
    }

    @Test
    func roundTrip_encodeAndDecode_preservesValues() throws {
        let original = ChapterSummary(chapterNumber: 42, summary: "An unexpected ally appears.")

        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ChapterSummary.self, from: encoded)

        #expect(decoded == original)
    }
}
