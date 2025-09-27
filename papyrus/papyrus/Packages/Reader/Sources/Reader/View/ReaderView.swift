//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI
import UIKit

struct ReaderView: View {
    @EnvironmentObject var store: ReaderStore
    @State private var isMenuOpen: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var mainCharacter: String = ""
    @State private var settingDetails: String = ""
    @FocusState private var focusedField: Field?
    @State private var keyboardHeight: CGFloat = 0
    @State private var showStoryForm: Bool = false
    
    enum Field {
        case mainCharacter
        case settingDetails
    }
    
    // Example story titles
    let storyTitles = [
        "The Forgotten Kingdom",
        "Whispers in the Sand",
        "The Last Pharaoh's Secret",
        "Echoes of Alexandria",
        "The Scribe's Tale",
        "Beneath the Pyramid",
        "The Desert Rose Mystery"
    ]
    
    init() {
        
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            // Main content
            VStack(spacing: 0) {
                // Top bar with menu button
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "text.alignleft")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                            .padding()
                    }
                    
                    Spacer()
                }
                .background(Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.8))
                
                VStack(alignment: .leading, spacing: 0) {
                    if let chapter = store.state.story?.chapters.last {
                        ScrollView {
                            Text(chapter.content)
                                .font(.custom("Georgia", size: 18))
                                .lineSpacing(8)
                                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 40)
                        }
                    } else {
                        // Welcome state
                        ZStack {
                            // Tap background to dismiss form
                            if showStoryForm {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            showStoryForm = false
                                            focusedField = nil
                                        }
                                    }
                            }
                            
                            // Centered content (scroll icon and welcome text)
                            if focusedField == nil && !showStoryForm {
                                WelcomeView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .transition(.opacity)
                            }
                            
                            // Bottom content (input fields and button)
                            VStack {
                                Spacer()
                                
                                if !showStoryForm {
                                    // Initial "New Story" button
                                    NewStoryButton(showStoryForm: $showStoryForm)
                                        .padding(.bottom, 50)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity)
                                        ))
                                } else {
                                    // Story form
                                    NewStoryForm(
                                        focusedField: $focusedField,
                                        showStoryForm: $showStoryForm
                                    )
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .move(edge: .bottom).combined(with: .opacity)
                                    ))
                                    .onTapGesture {
                                        // Prevent dismissal when tapping on the form itself
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .animation(.easeInOut(duration: 0.3), value: focusedField)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showStoryForm)
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                            keyboardHeight = 0
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .scrollBounceBehavior(.basedOnSize)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.startLocation.x < 20 && value.translation.width > 0 {
                            dragOffset = min(value.translation.width, 280)
                        }
                    }
                    .onEnded { value in
                        if dragOffset > 100 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isMenuOpen = true
                            }
                        }
                        dragOffset = 0
                    }
            )
            
            // Side menu overlay
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen = false
                        }
                    }
            }
            
            // Side menu
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
                            ForEach(storyTitles, id: \.self) { title in
                                Button(action: {
                                    // TODO: Load selected story
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isMenuOpen = false
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "book.closed")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                        
                                        Text(title)
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
                                        .opacity(title == storyTitles.first ? 1 : 0)
                                )
                                
                                Divider()
                                    .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2))
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
//        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    ReaderView()
}
