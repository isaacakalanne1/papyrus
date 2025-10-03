//
//  ReaderReducerTests.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
@testable import Reader

class ReaderReducerTests {

    @Test(arguments: [
        true,
        false
    ])
    func setShowStoryForm(boolValue: Bool) {
        let initialState = ReaderState()
        var expectedState = initialState
        expectedState.showStoryForm = boolValue
        
        let newState = readerReducer(
            initialState,
            .setShowStoryForm(boolValue)
        )
        #expect(newState == expectedState)
    }
}
