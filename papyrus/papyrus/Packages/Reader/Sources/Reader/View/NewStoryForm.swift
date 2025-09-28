//
//  NewStoryForm.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI

struct NewStoryForm: View {
    @FocusState.Binding var focusedField: ReaderView.Field?
    @EnvironmentObject var store: ReaderStore
    @Binding var showStoryForm: Bool
    
    var body: some View {
        let mainCharacter: Binding<String> = .init {
            store.state.mainCharacter
        } set: {
            store.dispatch(.updateMainCharacter($0))
        }
        
        let settingDetails: Binding<String> = .init {
            store.state.setting
        } set: {
            store.dispatch(.updateSetting($0))
        }

        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 24) {
                // Form header with close button
                HStack {
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
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showStoryForm = false
                            focusedField = nil
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.15))
                            )
                    }
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
                    
                    TextField("Enter a name...", text: mainCharacter)
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
                    
                    TextField("Describe the world...", text: settingDetails, axis: .vertical)
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
            DisablablePrimaryButton(
                title: "Create Story",
                icon: "pencil.and.ruler",
                size: .medium,
                isDisabled: mainCharacter.wrappedValue.isEmpty
            ) {
                store.dispatch(.createStory)
            }
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
    }
}
