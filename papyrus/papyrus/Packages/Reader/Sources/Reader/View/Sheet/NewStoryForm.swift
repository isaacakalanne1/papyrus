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
                text: mainCharacter,
                focusedField: $focusedField,
                fieldValue: .mainCharacter
            ) {
                focusedField = .settingDetails
            }
                
            FormFieldView(
                label: "Setting & Details",
                placeholder: "E.g, Living in Los Angeles, has famous superheroes as clients",
                text: settingDetails,
                focusedField: $focusedField,
                fieldValue: .settingDetails
            ) {
                focusedField = nil
            }

            Spacer()

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
