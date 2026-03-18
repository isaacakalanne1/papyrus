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
    @FocusState private var focusedField: ReaderField?
    @State var mainCharacter: String = ""
    @State var settingDetails: String = ""
    @State private var showMainCharacterHint = false
    @State private var showSettingDetailsHint = false
    
    var body: some View {

        VStack(spacing: 20) {
            // Header
            HStack {
                Text(store.state.isSequelMode ? "Create Sequel" : "New Story")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(PapyrusColor.textPrimary.color)
                
                Spacer()
                
                // Close button
                MenuButton(type: .close) {
                    store.dispatch(.setShowStoryForm(false))
                    store.dispatch(.setIsSequelMode(false))
                    store.dispatch(.setFocusedField(nil))
                }
            }
                
            FormFieldView(
                label: "Main Character",
                placeholder: "E.g, Sherlock Holmes",
                text: $mainCharacter,
                equals: .mainCharacter,
                showHint: showMainCharacterHint,
                hintText: showMainCharacterHint ? "Please provide a main character for your story" : nil
            ) {
                store.dispatch(.setFocusedField(.settingDetails))
            }
                
            FormFieldView(
                label: "Setting & Details",
                placeholder: "E.g, Living in Los Angeles, has famous superheroes as clients",
                text: $settingDetails,
                equals: .settingDetails,
                showHint: showSettingDetailsHint,
                hintText: showSettingDetailsHint ? "Add some details about the setting" : nil
            ) {
                store.dispatch(.setFocusedField(nil))
            }

            // Write chapter button
            PrimaryButton(
                type: store.state.isSequelMode ? .createSequel : .createStory,
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
                    if store.state.isSequelMode {
                        store.dispatch(.createSequel)
                    } else {
                        store.dispatch(.createStory)
                    }
                }
            }
            
            Spacer()
        }
        .padding(24)
        .environment(\.readerFocusedField, $focusedField)
        .onChange(of: store.state.focusedField) { oldValue, newValue in
            focusedField = newValue
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if store.state.focusedField != newValue {
                store.dispatch(.setFocusedField(newValue))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            PapyrusColor.background.color,
                            PapyrusColor.backgroundSecondary.color
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        store.dispatch(.setFocusedField(nil))
                    }
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(PapyrusColor.accent.color)
                }
            }
        }
        .onTapGesture {
            store.dispatch(.setFocusedField(nil))
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
