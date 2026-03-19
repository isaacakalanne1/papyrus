import SwiftUI
import PapyrusStyleKit

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
                Divider()
                    .background(PapyrusColor.borderSecondary.color(in: colorScheme))
                ScrollView {
                    VStack(spacing: 0) {
                        if selectedSchemeName != defaultSchemeName {
                            defaultSchemeRow
                            Divider()
                                .background(PapyrusColor.borderSecondary.color(in: colorScheme))
                                .padding(.horizontal, 20)
                        }
                        otherSchemesList
                    }
                }
            }
            closeButton
        }
        .background(PapyrusColor.background.color(in: colorScheme))
    }

    private var header: some View {
        HStack {
            Text("Colour Scheme")
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
        VStack(spacing: 0) {
            ForEach(otherSchemes, id: \.self) { schemeName in
                schemeRow(schemeName: schemeName, subtitle: nil)
                Divider()
                    .background(PapyrusColor.borderSecondary.color(in: colorScheme))
                    .padding(.horizontal, 20)
            }
        }
    }

    private func schemeRow(schemeName: PapyrusColorSchemeName, subtitle: String?) -> some View {
        let isSelected = schemeName == selectedSchemeName
        return Button(action: {
            store.dispatch(.selectColorScheme(schemeName))
            isPresented = false
        }) {
            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(schemeName.scheme.background)
                    .frame(width: 28, height: 28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(schemeName.scheme.borderPrimary, lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(schemeName.displayName)
                        .font(.custom(store.state.selectedFontName, size: 18))
                        .foregroundColor(isSelected ?
                            PapyrusColor.accent.color(in: colorScheme) :
                            PapyrusColor.textPrimary.color(in: colorScheme))
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 11))
                            .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(PapyrusColor.accent.color(in: colorScheme))
                }
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, 20)
            .background(
                isSelected
                    ? PapyrusColor.backgroundSecondary.color(in: colorScheme).opacity(0.8)
                    : Color.clear
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
