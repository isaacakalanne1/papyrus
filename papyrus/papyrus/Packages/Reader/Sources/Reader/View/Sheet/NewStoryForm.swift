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
                focusedField: $focusedField
            ) {
                focusedField = .settingDetails
            }
                
            FormFieldView(
                label: "Setting & Details",
                placeholder: "E.g, Living in Los Angeles, has famous superheroes as clients",
                text: $settingDetails,
                focusedField: $focusedField
            ) {
                focusedField = nil
            }

            Spacer()

            // Write chapter button
            PrimaryButton(
                type: isSequelMode ? .createSequel : .createStory,
                size: .medium,
                isDisabled: mainCharacter.isEmpty || settingDetails.isEmpty,
                isLoading: store.state.isLoading
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
        .onChange(of: mainCharacter) { oldValue, newValue in
            store.dispatch(.updateMainCharacter(newValue))
        }
        .onChange(of: settingDetails) { oldValue, newValue in
            store.dispatch(.updateSetting(newValue))
        }
    }
}
