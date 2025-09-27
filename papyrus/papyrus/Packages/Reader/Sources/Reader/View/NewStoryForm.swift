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
            Button(action: {
                store.dispatch(.createStory)
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil.and.ruler")
                        .font(.system(size: 18))
                    Text("Create Story")
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
                        .opacity(mainCharacter.wrappedValue.isEmpty ? 0.6 : 1.0)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
            }
            .disabled(mainCharacter.wrappedValue.isEmpty)
            .scaleEffect(mainCharacter.wrappedValue.isEmpty ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: mainCharacter.wrappedValue.isEmpty)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
    }
}
