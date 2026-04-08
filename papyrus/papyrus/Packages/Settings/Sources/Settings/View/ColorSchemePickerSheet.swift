import PapyrusStyleKit
import SwiftUI

struct ColorSchemePickerSheet: View {
    @EnvironmentObject var store: SettingsStore
    @Binding var isPresented: Bool
    @Environment(\.papyrusColorScheme) private var colorScheme

    private let defaultSchemeName = PapyrusColorSchemeName.parchment

    private var selectedSchemeName: PapyrusColorSchemeName {
        store.state.selectedColorSchemeName
    }

    private var otherSchemes: [PapyrusColorSchemeName] {
        PapyrusColorSchemeName.allCases.filter { $0 != defaultSchemeName && $0 != selectedSchemeName }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                header
                Divider()
                    .background(PapyrusColor.borderSecondary.color(in: colorScheme))
                selectedSchemeRow
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                Divider()
                    .background(PapyrusColor.borderSecondary.color(in: colorScheme))
                    .padding(.top, 12)
                ScrollView {
                    VStack(spacing: 10) {
                        if selectedSchemeName != defaultSchemeName {
                            defaultSchemeRow
                                .padding(.horizontal, 16)
                        }
                        otherSchemesList
                    }
                    .padding(.top, 12)
                }
            }
            closeButton
        }
        .background(PapyrusColor.background.color(in: colorScheme))
    }

    private var header: some View {
        HStack {
            Text("Color Scheme")
                .font(.custom(store.state.selectedFontName, size: 20))
                .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var closeButton: some View {
        MenuButton(type: .largeClose) {
            isPresented = false
        }
        .padding(24)
    }

    private var selectedSchemeRow: some View {
        schemeRow(schemeName: selectedSchemeName, subtitle: "Selected")
    }

    private var defaultSchemeRow: some View {
        schemeRow(schemeName: defaultSchemeName, subtitle: "Default")
    }

    private var otherSchemesList: some View {
        VStack(spacing: 10) {
            ForEach(otherSchemes, id: \.self) { schemeName in
                schemeRow(schemeName: schemeName, subtitle: nil)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func schemeRow(schemeName: PapyrusColorSchemeName, subtitle: String?) -> some View {
        let isSelected = schemeName == selectedSchemeName
        let rowScheme = schemeName.scheme
        return Button(action: {
            store.dispatch(.selectColorScheme(schemeName))
            isPresented = false
        }) {
            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(rowScheme.accent)
                    .frame(width: 28, height: 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(rowScheme.borderPrimary, lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(schemeName.displayName)
                        .font(.custom(store.state.selectedFontName, size: 18))
                        .foregroundColor(rowScheme.textPrimary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 11))
                            .foregroundColor(rowScheme.textSecondary)
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(rowScheme.accent)
                }
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, 16)
            .background(isSelected ? rowScheme.backgroundSecondary : rowScheme.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(rowScheme.borderSecondary, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
