//
//  StoryMenu.swift
//  Reader
//
//  Created by Isaac Akalanne on 28/09/2025.
//

import SwiftUI
import TextGeneration

struct StoryMenu: View {
    @EnvironmentObject var store: ReaderStore
    @Binding var isMenuOpen: Bool
    let dragOffset: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                // Menu header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Stories")
                        .font(.custom("Georgia", size: 24))
                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                    
                    Divider()
                        .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.5))
                }
                .padding()
                .padding(.top, 20)
                
                // Story list
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if let stories = store.state.loadedStories, !stories.isEmpty {
                            ForEach(stories, id: \.id) { story in
                                Button(action: {
                                    store.dispatch(.setStory(story))
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isMenuOpen = false
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "book.closed")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                        
                                        Text(story.title.isEmpty ? "Untitled Story" : story.title)
                                            .font(.custom("Georgia", size: 16))
                                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                }
                                .background(
                                    Color(red: 0.6, green: 0.5, blue: 0.4)
                                        .opacity(0.1)
                                        .opacity(story.id == stories.first?.id ? 1 : 0)
                                )
                                
                                Divider()
                                    .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2))
                            }
                        } else {
                            Text("No saved stories yet")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                .padding()
                        }
                    }
                }
                
                Spacer()
            }
            .frame(width: 280)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.98, green: 0.95, blue: 0.89),
                        Color(red: 0.96, green: 0.92, blue: 0.84)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .offset(x: isMenuOpen ? 0 : -280 + dragOffset)
            
            Spacer()
        }
    }
}
