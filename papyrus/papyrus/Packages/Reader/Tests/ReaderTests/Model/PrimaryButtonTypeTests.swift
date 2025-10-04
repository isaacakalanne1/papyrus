//
//  PrimaryButtonTypeTests.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
@testable import Reader

class PrimaryButtonTypeTests {
    
    @Test
    func newStory() {
        let buttonType = PrimaryButtonType.newStory
        #expect(buttonType.title == "New Story")
        #expect(buttonType.icon == "plus.circle.fill")
    }
    
    @Test
    func nextChapter() {
        let buttonType = PrimaryButtonType.nextChapter
        #expect(buttonType.title == "Next Chapter")
        #expect(buttonType.icon == "book.pages")
    }
    
    @Test
    func createSequel() {
        let buttonType = PrimaryButtonType.createSequel
        #expect(buttonType.title == "Create Sequel")
        #expect(buttonType.icon == "book.closed")
    }
    
    @Test
    func createStory() {
        let buttonType = PrimaryButtonType.createStory
        #expect(buttonType.title == "Create Story")
        #expect(buttonType.icon == "pencil.and.ruler")
    }
}