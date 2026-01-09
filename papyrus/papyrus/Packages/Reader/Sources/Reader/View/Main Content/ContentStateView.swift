//
//  ContentStateView.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

struct ContentStateView: View {
    @EnvironmentObject var store: ReaderStore
    
    let startScrollOffsetTimer: () -> Void
    
    var body: some View {
        switch store.state.contentState {
        case .welcome:
            WelcomeView()
        case .story(let story):
            StoryContentView(
                story: story,
                startScrollOffsetTimer: startScrollOffsetTimer
            )
        }
    }
}
