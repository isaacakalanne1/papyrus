//
//  StoryDetailsPopup.swift
//  Reader
//
//  Created by Isaac Akalanne on 02/10/2025.
//

import SwiftUI
import TextGeneration
import PapyrusStyleKit

struct StoryDetailsPopup: View {
    let story: Story
    @Binding var isPresented: Bool
    @State private var copiedField: CopiedField? = nil
    
    enum CopiedField {
        case title
        case mainCharacter
        case storyDetails
    }
    
    var body: some View {
        ZStack {
            // Invisible background to catch taps
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 20) {
            // Header
            HStack {
                Text("Story Details")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(PapyrusColor.textPrimary.color)
                
                Spacer()
                
                MenuButton(type: .close) {
                    isPresented = false
                }
            }
            
            // Title section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Title")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = story.title.isEmpty ? "Untitled Story" : story.title
                        withAnimation(.easeInOut(duration: 0.2)) {
                            copiedField = .title
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if copiedField == .title {
                                    copiedField = nil
                                }
                            }
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: copiedField == .title ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 12))
                            Text(copiedField == .title ? "Copied" : "Copy")
                                .font(.custom("Georgia", size: 12))
                        }
                        .foregroundColor(copiedField == .title ? Color.green : Color(red: 0.6, green: 0.5, blue: 0.4))
                    }
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        Text(story.title.isEmpty ? "Untitled Story" : story.title)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(PapyrusColor.textPrimary.color)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .id("titleText")
                    }
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.1))
                    )
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
            
            // Main character section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Main Character")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = story.mainCharacter.isEmpty ? "Not specified" : story.mainCharacter
                        withAnimation(.easeInOut(duration: 0.2)) {
                            copiedField = .mainCharacter
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if copiedField == .mainCharacter {
                                    copiedField = nil
                                }
                            }
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: copiedField == .mainCharacter ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 12))
                            Text(copiedField == .mainCharacter ? "Copied" : "Copy")
                                .font(.custom("Georgia", size: 12))
                        }
                        .foregroundColor(copiedField == .mainCharacter ? Color.green : Color(red: 0.6, green: 0.5, blue: 0.4))
                    }
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        Text(story.mainCharacter.isEmpty ? "Not specified" : story.mainCharacter)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(PapyrusColor.textPrimary.color)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .id("mainCharacterText")
                    }
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.1))
                    )
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
            
            // Setting details section with scrollview
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Story Details")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = story.setting.isEmpty ? "Not specified" : story.setting
                        withAnimation(.easeInOut(duration: 0.2)) {
                            copiedField = .storyDetails
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if copiedField == .storyDetails {
                                    copiedField = nil
                                }
                            }
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: copiedField == .storyDetails ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 12))
                            Text(copiedField == .storyDetails ? "Copied" : "Copy")
                                .font(.custom("Georgia", size: 12))
                        }
                        .foregroundColor(copiedField == .storyDetails ? Color.green : Color(red: 0.6, green: 0.5, blue: 0.4))
                    }
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        Text(story.setting.isEmpty ? "Not specified" : story.setting)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(PapyrusColor.textPrimary.color)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .id("settingText")
                    }
                    .frame(height: 150)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.1))
                    )
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
            
                Spacer()
            }
            .padding(24)
            .frame(width: 350, height: 450)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.background.color,
                                Color(red: 0.96, green: 0.92, blue: 0.84)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .onTapGesture { } // Prevent tap from propagating to background
        }
    }
}
