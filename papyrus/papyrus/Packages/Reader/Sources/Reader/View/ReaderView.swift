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
                    if let chapter = store.state.chapter {
                        ScrollView {
                            Text(chapter)
                                .font(.custom("Georgia", size: 18))
                                .lineSpacing(8)
                                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 40)
                        }
                    } else {
                        // Welcome state
                        ZStack {
                            // Centered content (scroll icon and welcome text)
                            if focusedField == nil {
                                VStack(spacing: 16) {
                                    Image(systemName: "scroll.fill")
                                        .font(.system(size: 64))
                                        .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                        .opacity(0.5)
                                        .padding(.top, 50)
                                    
                                    VStack(spacing: 16) {
                                        Text("Welcome to Papyrus")
                                            .font(.custom("Georgia", size: 28))
                                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                        
                                        Text("Begin your tale...")
                                            .font(.custom("Georgia", size: 16))
                                            .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                                            .italic()
                                    }

                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .transition(.opacity)
                            }
                            
                            // Bottom content (input fields and button)
                            VStack {
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Main Character")
                                        .font(.custom("Georgia", size: 14))
                                        .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                                    
                                    TextField("Enter a name...", text: $mainCharacter)
                                        .font(.custom("Georgia", size: 16))
                                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color(red: 0.94, green: 0.90, blue: 0.82))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2), lineWidth: 1)
                                                )
                                        )
                                        .focused($focusedField, equals: .mainCharacter)
                                        .submitLabel(.next)
                                        .onSubmit {
                                            focusedField = .settingDetails
                                        }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Setting")
                                        .font(.custom("Georgia", size: 14))
                                        .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                                    
                                    TextField("Describe the world...", text: $settingDetails)
                                        .font(.custom("Georgia", size: 16))
                                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color(red: 0.94, green: 0.90, blue: 0.82))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2), lineWidth: 1)
                                                )
                                        )
                                        .focused($focusedField, equals: .settingDetails)
                                        .submitLabel(.return)
                                        .onSubmit {
                                            focusedField = nil
                                        }
                                }
                                
                                    Text("Tip: Write a story about your favourite character")
                                        .font(.custom("Georgia", size: 14))
                                        .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                                }
                                .padding(.top, 20)
                                
                                // Write chapter button
                                Button(action: {
                                    store.dispatch(.createChapter)
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                        Text("Write chapter")
                                    }
                                    .font(.custom("Georgia", size: 18))
                                    .foregroundColor(Color(red: 0.98, green: 0.95, blue: 0.89))
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(red: 0.4, green: 0.35, blue: 0.3))
                                            .opacity(mainCharacter.isEmpty ? 0.5 : 1.0)
                                    )
                                }
                                .disabled(mainCharacter.isEmpty)
                                .padding(.bottom, 20)
                            }
                            .padding(.horizontal, 32)
                            .background(Color.white.opacity(0.001)) // Invisible background for tap detection
                            .onTapGesture {
                                focusedField = nil
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: focusedField)
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
