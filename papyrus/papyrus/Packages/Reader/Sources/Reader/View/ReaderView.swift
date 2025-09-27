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
                                
                                VStack(spacing: 0) {
                                    // Form container with manuscript-like appearance
                                    VStack(alignment: .leading, spacing: 24) {
                                        // Form header
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("New Tale")
                                                .font(.custom("Georgia", size: 20))
                                                .fontWeight(.medium)
                                                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                            
                                            Rectangle()
                                                .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3))
                                                .frame(height: 1)
                                                .frame(maxWidth: 120)
                                        }
                                        .padding(.bottom, 8)
                                        
                                        // Character field
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Image(systemName: "person.circle")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                                Text("Main Character")
                                                    .font(.custom("Georgia", size: 15))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                                            }
                                            
                                            TextField("Enter a name...", text: $mainCharacter)
                                                .font(.custom("Georgia", size: 16))
                                                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 14)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color(red: 0.92, green: 0.88, blue: 0.79))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(
                                                                    focusedField == .mainCharacter 
                                                                    ? Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.6)
                                                                    : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2), 
                                                                    lineWidth: focusedField == .mainCharacter ? 2 : 1
                                                                )
                                                        )
                                                )
                                                .focused($focusedField, equals: .mainCharacter)
                                                .submitLabel(.next)
                                                .onSubmit {
                                                    focusedField = .settingDetails
                                                }
                                        }
                                        
                                        // Setting field
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Image(systemName: "globe")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                                Text("Setting & World")
                                                    .font(.custom("Georgia", size: 15))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                                            }
                                            
                                            TextField("Describe the world...", text: $settingDetails, axis: .vertical)
                                                .font(.custom("Georgia", size: 16))
                                                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                                .lineLimit(2...4)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 14)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color(red: 0.92, green: 0.88, blue: 0.79))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(
                                                                    focusedField == .settingDetails 
                                                                    ? Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.6)
                                                                    : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2), 
                                                                    lineWidth: focusedField == .settingDetails ? 2 : 1
                                                                )
                                                        )
                                                )
                                                .focused($focusedField, equals: .settingDetails)
                                                .submitLabel(.return)
                                                .onSubmit {
                                                    focusedField = nil
                                                }
                                        }
                                        
                                        // Subtle tip
                                        HStack {
                                            Image(systemName: "lightbulb.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.6))
                                            Text("Try starting with your favorite character or a world you've always imagined")
                                                .font(.custom("Georgia", size: 13))
                                                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                                                .italic()
                                        }
                                        .padding(.top, 4)
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 28)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(red: 0.96, green: 0.93, blue: 0.86),
                                                        Color(red: 0.94, green: 0.90, blue: 0.82)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.15), lineWidth: 1)
                                            )
                                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                                    )
                                    
                                    // Write chapter button
                                    Button(action: {
                                        store.dispatch(.createChapter)
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "pencil.and.ruler")
                                                .font(.system(size: 18))
                                            Text("Begin Writing")
                                                .font(.custom("Georgia", size: 18))
                                                .fontWeight(.medium)
                                        }
                                        .foregroundColor(Color(red: 0.98, green: 0.95, blue: 0.89))
                                        .padding(.horizontal, 36)
                                        .padding(.vertical, 18)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [
                                                            Color(red: 0.45, green: 0.40, blue: 0.35),
                                                            Color(red: 0.35, green: 0.30, blue: 0.25)
                                                        ]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .opacity(mainCharacter.isEmpty ? 0.6 : 1.0)
                                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                        )
                                    }
                                    .disabled(mainCharacter.isEmpty)
                                    .scaleEffect(mainCharacter.isEmpty ? 0.98 : 1.0)
                                    .animation(.easeInOut(duration: 0.15), value: mainCharacter.isEmpty)
                                    .padding(.top, 24)
                                    .padding(.bottom, 32)
                                }
                            }
                            .padding(.horizontal, 20)
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
