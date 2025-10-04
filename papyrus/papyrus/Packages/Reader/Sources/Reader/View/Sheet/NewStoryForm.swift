//
//  NewStoryForm.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI

struct NewStoryForm: View {
    @EnvironmentObject var store: ReaderStore
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var isSequelMode: Bool
    
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

        VStack(spacing: 20) {
            // Header
            HStack {
                Text(isSequelMode ? "Create Sequel" : "New Story")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                
                Spacer()
                
                MenuButton(type: .close) {
                    store.dispatch(.setShowStoryForm(false))
                    isSequelMode = false
                    focusedField = nil
                }
            }
                
            // Main character section
            VStack(alignment: .leading, spacing: 8) {
                Text("Main Character")
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                
                TextField("E.g, Sherlock Holmes", text: mainCharacter)
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.1))
                    )
                    .focused($focusedField, equals: .mainCharacter)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .settingDetails
                    }
            }
                
            // Story details section
            VStack(alignment: .leading, spacing: 8) {
                Text("Setting & Details")
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.1))
                        .frame(height: 120)
                    
                    TextField("E.g, Living in Los Angeles, has famous superheroes as clients", text: settingDetails, axis: .vertical)
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                        .lineLimit(3...6)
                        .padding(12)
                        .focused($focusedField, equals: .settingDetails)
                        .submitLabel(.return)
                        .onSubmit {
                            focusedField = nil
                        }
                }
            }
            
            // Write chapter button
            PrimaryButton(
                type: isSequelMode ? .createSequel : .createStory,
                size: .medium,
                isDisabled: mainCharacter.wrappedValue.isEmpty || settingDetails.wrappedValue.isEmpty || store.state.isLoading
            ) {
                if isSequelMode {
                    store.dispatch(.createSequel)
                } else {
                    store.dispatch(.createStory)
                }
            }
            
            Spacer()
        }
        .padding(24)
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
        }
    }
}
