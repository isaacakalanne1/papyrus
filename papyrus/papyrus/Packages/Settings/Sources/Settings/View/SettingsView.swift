import SwiftUI
import ReduxKit
import PapyrusStyleKit

public struct SettingsView: View {
    @EnvironmentObject var store: SettingsStore
    @State private var isFontPickerPresented = false

    var selectedTextSize: TextSize {
        store.state.selectedTextSize
    }

    var selectedFontName: String {
        store.state.selectedFontName
    }

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MenuMainHeader("Settings", fontName: selectedFontName)

            VStack(alignment: .leading, spacing: 20) {
                textSizeSection
                fontSection
            }
        }
        .background(PapyrusColor.background.color)
        .sheet(isPresented: $isFontPickerPresented) {
            FontPickerSheet(isPresented: $isFontPickerPresented)
                .environmentObject(store)
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
                .stroke(PapyrusColor.borderSecondary.color, lineWidth: 1)
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
                    PapyrusColor.accent.color :
                    PapyrusColor.textSecondary.color)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    Group {
                        if size == selectedTextSize {
                            PapyrusColor.backgroundSecondary.color.opacity(0.8)
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
                    .foregroundColor(PapyrusColor.textSecondary.color)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(PapyrusColor.textSecondary.color)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(PapyrusColor.borderSecondary.color, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }
}
