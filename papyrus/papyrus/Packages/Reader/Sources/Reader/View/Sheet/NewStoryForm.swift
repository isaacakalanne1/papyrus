//
//  NewStoryForm.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI
import PapyrusStyleKit
import TextGeneration

struct NewStoryForm: View {
    @EnvironmentObject var store: ReaderStore
    @FocusState private var focusedField: ReaderField?
    @State var mainCharacter: String = ""
    @State var settingDetails: String = ""
    @State private var showMainCharacterHint = false
    @State private var showSettingDetailsHint = false
    @State private var showMoreOptions = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(store.state.isSequelMode ? "Create Sequel" : "New Story")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(PapyrusColor.textPrimary.color)

                Spacer()

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

            // More options collapsible section
            VStack(spacing: 12) {
                HStack {
                    Text("More options")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(PapyrusColor.textSecondary.color)
                    Spacer()
                    Image(systemName: showMoreOptions ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(PapyrusColor.textSecondary.color)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showMoreOptions.toggle()
                    }
                }

                if showMoreOptions {
                    HStack {
                        Text("Perspective")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(PapyrusColor.textPrimary.color)
                        Spacer()
                        HStack(spacing: 8) {
                            perspectiveButton(label: "1st person", value: .firstPerson)
                            perspectiveButton(label: "3rd person", value: .thirdPerson)
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            PrimaryButton(
                type: store.state.isSequelMode ? .createSequel : .createStory,
                size: .medium,
                isDisabled: false,
                isLoading: store.state.isLoading
            ) {
                let isMainCharacterEmpty = mainCharacter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let isSettingDetailsEmpty = settingDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

                if isMainCharacterEmpty || isSettingDetailsEmpty {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showMainCharacterHint = isMainCharacterEmpty
                        showSettingDetailsHint = isSettingDetailsEmpty
                    }
                } else {
                    store.dispatch(store.state.isSequelMode ? .createSequel : .createStory)
                }
            }

            Spacer()
        }
        .padding(24)
        .environment(\.readerFocusedField, $focusedField)
        .onChange(of: store.state.focusedField) { _, newValue in
            focusedField = newValue
        }
        .onChange(of: focusedField) { _, newValue in
            if store.state.focusedField != newValue {
                store.dispatch(.setFocusedField(newValue))
            }
        }
        .onChange(of: mainCharacter) { _, newValue in
            store.dispatch(.updateMainCharacter(newValue))
            if showMainCharacterHint && !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showMainCharacterHint = false
                }
            }
        }
        .onChange(of: settingDetails) { _, newValue in
            store.dispatch(.updateSetting(newValue))
            if showSettingDetailsHint && !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSettingDetailsHint = false
                }
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
    }

    private func perspectiveButton(label: String, value: StoryPerspective) -> some View {
        Button(label) {
            store.dispatch(.updatePerspective(value))
        }
        .font(.custom("Georgia", size: 14))
        .foregroundColor(store.state.perspective == value ? PapyrusColor.accent.color : PapyrusColor.textSecondary.color)
    }
}
