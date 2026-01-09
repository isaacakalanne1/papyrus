//
//  ContentStateView.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

struct ContentStateView: View {
    @EnvironmentObject var store: ReaderStore
    @Binding var isSequelMode: Bool
    @Binding var currentScrollOffset: CGFloat
    @Binding var scrollViewHeight: CGFloat
    
    let startScrollOffsetTimer: () -> Void
    
    var body: some View {
        switch store.state.contentState {
        case .welcome:
            WelcomeView(
                isSequelMode: $isSequelMode
            )
        case .story(let story):
            StoryContentView(
                story: story,
                isSequelMode: $isSequelMode,
                currentScrollOffset: $currentScrollOffset,
                scrollViewHeight: $scrollViewHeight,
                startScrollOffsetTimer: startScrollOffsetTimer
            )
        }
    }
}
