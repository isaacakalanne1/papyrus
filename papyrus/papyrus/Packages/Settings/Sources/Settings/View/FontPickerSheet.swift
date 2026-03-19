import SwiftUI
import UIKit
import PapyrusStyleKit

struct FontPickerSheet: View {
    @EnvironmentObject var store: SettingsStore
    @Binding var isPresented: Bool

    private let defaultFontName = "Georgia"

    private var selectedFontName: String {
        store.state.selectedFontName
    }

    private var otherFonts: [String] {
        UIFont.familyNames.sorted().filter { $0 != defaultFontName && $0 != selectedFontName }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                header
                Divider()
                    .background(PapyrusColor.borderSecondary.color)
                selectedFontRow
                Divider()
                    .background(PapyrusColor.borderSecondary.color)
                ScrollView {
                    VStack(spacing: 0) {
                        if selectedFontName != defaultFontName {
                            defaultFontRow
                            Divider()
                                .background(PapyrusColor.borderSecondary.color)
                                .padding(.horizontal, 20)
                        }
                        otherFontsList
                    }
                }
            }
            closeButton
        }
        .background(PapyrusColor.background.color)
    }

    private var header: some View {
        HStack {
            Text("Font")
                .font(.custom(selectedFontName, size: 20))
                .foregroundColor(PapyrusColor.textPrimary.color)
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

    private var selectedFontRow: some View {
        fontRow(fontName: selectedFontName, subtitle: "Selected")
    }

    private var defaultFontRow: some View {
        fontRow(fontName: defaultFontName, subtitle: "Default")
    }

    private var otherFontsList: some View {
        VStack(spacing: 0) {
            ForEach(otherFonts, id: \.self) { fontName in
                fontRow(fontName: fontName, subtitle: nil)
                Divider()
                    .background(PapyrusColor.borderSecondary.color)
                    .padding(.horizontal, 20)
            }
        }
    }

    private func fontRow(fontName: String, subtitle: String?) -> some View {
        let isSelected = fontName == selectedFontName
        return Button(action: {
            store.dispatch(.selectFont(fontName))
            isPresented = false
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(fontName)
                        .font(.custom(fontName, size: 18))
                        .foregroundColor(isSelected ?
                            PapyrusColor.accent.color :
                            PapyrusColor.textPrimary.color)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 11))
                            .foregroundColor(PapyrusColor.textSecondary.color)
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(PapyrusColor.accent.color)
                }
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, 20)
            .background(
                isSelected
                    ? PapyrusColor.backgroundSecondary.color.opacity(0.8)
                    : Color.clear
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
