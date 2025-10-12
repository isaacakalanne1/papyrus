//
//  ContentStateView.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

struct ContentStateView: View {
    @EnvironmentObject var store: ReaderStore
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var isSequelMode: Bool
    @Binding var scrollViewHeight: CGFloat
    
    var body: some View {
        switch store.state.contentState {
        case .welcome:
            WelcomeView(
                isSequelMode: $isSequelMode
            )
        case .story(let story):
            StoryContentView(
                story: story,
                focusedField: $focusedField,
                isSequelMode: $isSequelMode,
                scrollViewHeight: $scrollViewHeight
            )
        }
    }
}
