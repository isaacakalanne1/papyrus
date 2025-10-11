//
//  NewStoryForm.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI
import PapyrusStyleKit

struct NewStoryForm: View {
    @EnvironmentObject var store: ReaderStore
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var isSequelMode: Bool
    @State var mainCharacter: String = ""
    @State var settingDetails: String = ""
    @State private var showMainCharacterHint = false
    @State private var showSettingDetailsHint = false
    
    var body: some View {

        VStack(spacing: 20) {
            // Header
            HStack {
                Text(isSequelMode ? "Create Sequel" : "New Story")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(PapyrusColor.textPrimary.color)
                
                Spacer()
                
                MenuButton(type: .close) {
                    store.dispatch(.setShowStoryForm(false))
                    isSequelMode = false
                    focusedField = nil
                }
            }
                
            FormFieldView(
                label: "Main Character",
                placeholder: "E.g, Sherlock Holmes",
                text: $mainCharacter,
                focusedField: $focusedField,
                showHint: showMainCharacterHint,
                hintText: showMainCharacterHint ? "Please provide a main character for your story" : nil
            ) {
                focusedField = .settingDetails
            }
                
            FormFieldView(
                label: "Setting & Details",
                placeholder: "E.g, Living in Los Angeles, has famous superheroes as clients",
                text: $settingDetails,
                focusedField: $focusedField,
                showHint: showSettingDetailsHint,
                hintText: showSettingDetailsHint ? "Add some details about the setting" : nil
            ) {
                focusedField = nil
            }

            Spacer()

            // Write chapter button
            PrimaryButton(
                type: isSequelMode ? .createSequel : .createStory,
                size: .medium,
                isDisabled: false,
                isLoading: store.state.isLoading
            ) {
                // Check if fields are filled
                let isMainCharacterEmpty = mainCharacter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isSettingDetailsEmpty = settingDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                
                if isMainCharacterEmpty || isSettingDetailsEmpty {
                    // Show hints for empty fields
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showMainCharacterHint = isMainCharacterEmpty
                        showSettingDetailsHint = isSettingDetailsEmpty
                    }
                } else {
                    // Proceed with creation
                    if isSequelMode {
                        store.dispatch(.createSequel)
                    } else {
                        store.dispatch(.createStory)
                    }
                }
            }
            
            Spacer()
        }
        .padding(24)
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
        }
        .onChange(of: mainCharacter) { oldValue, newValue in
            store.dispatch(.updateMainCharacter(newValue))
        }
        .onChange(of: settingDetails) { oldValue, newValue in
            store.dispatch(.updateSetting(newValue))
        }
        .onChange(of: mainCharacter) { oldValue, newValue in
            if showMainCharacterHint && !newValue
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: .punctuationCharacters)
                .isEmpty {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showMainCharacterHint = false
                }
            }
        }
        .onChange(of: settingDetails) { oldValue, newValue in
            if showSettingDetailsHint && !newValue
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: .punctuationCharacters)
                .isEmpty {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSettingDetailsHint = false
                }
            }
        }
    }
}
