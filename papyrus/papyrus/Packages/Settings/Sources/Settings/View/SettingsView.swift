import SwiftUI
import ReduxKit
import PapyrusStyleKit

public struct SettingsView: View {
    @EnvironmentObject var store: SettingsStore
    @Environment(\.papyrusColorScheme) private var colorScheme
    @State private var isFontPickerPresented = false
    @State private var isColorSchemePickerPresented = false

    var selectedTextSize: TextSize {
        store.state.selectedTextSize
    }

    var selectedFontName: String {
        store.state.selectedFontName
    }

    var selectedColorSchemeName: PapyrusColorSchemeName {
        store.state.selectedColorSchemeName
    }

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MenuMainHeader("Settings", fontName: selectedFontName)

            VStack(alignment: .leading, spacing: 20) {
                textSizeSection
                fontSection
                colorSchemeSection
            }
        }
        .background(PapyrusColor.background.color(in: colorScheme))
        .sheet(isPresented: $isFontPickerPresented) {
            FontPickerSheet(isPresented: $isFontPickerPresented)
                .environmentObject(store)
        }
        .sheet(isPresented: $isColorSchemePickerPresented) {
            ColorSchemePickerSheet(isPresented: $isColorSchemePickerPresented)
                .environmentObject(store)
                .environment(\.papyrusColorScheme, colorScheme)
        }
    }

    private var textSizeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MenuSubheader("Text Size", fontName: selectedFontName)

            textSizeSelector
        }
    }

    private var textSizeSelector: some View {
        HStack(spacing: 0) {
            ForEach(TextSize.allCases, id: \.self) { size in
                textSizeButton(for: size)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }

    private func textSizeButton(for size: TextSize) -> some View {
        Button(action: {
            store.dispatch(.selectTextSize(size))
        }) {
            Text("A")
                .font(.custom(selectedFontName, size: size.fontSize * size.iconScale))
                .foregroundColor(size == selectedTextSize ?
                    PapyrusColor.accent.color(in: colorScheme) :
                    PapyrusColor.textSecondary.color(in: colorScheme))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    Group {
                        if size == selectedTextSize {
                            PapyrusColor.backgroundSecondary.color(in: colorScheme).opacity(0.8)
                        } else {
                            Color.clear
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var fontSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MenuSubheader("Font", fontName: selectedFontName)

            fontRow
        }
    }

    private var fontRow: some View {
        Button(action: {
            isFontPickerPresented = true
        }) {
            HStack {
                Text(selectedFontName)
                    .font(.custom(selectedFontName, size: selectedTextSize.fontSize))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }

    private var colorSchemeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MenuSubheader("Colour Scheme", fontName: selectedFontName)

            colorSchemeRow
        }
    }

    private var colorSchemeRow: some View {
        Button(action: {
            isColorSchemePickerPresented = true
        }) {
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(selectedColorSchemeName.scheme.accent)
                    .frame(width: 24, height: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(selectedColorSchemeName.scheme.borderPrimary, lineWidth: 1)
                    )

                Text(selectedColorSchemeName.displayName)
                    .font(.custom(selectedFontName, size: selectedTextSize.fontSize))
                    .foregroundColor(selectedColorSchemeName.scheme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }
}
