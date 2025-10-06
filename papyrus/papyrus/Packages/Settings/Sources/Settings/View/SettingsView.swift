import SwiftUI
import ReduxKit
import PapyrusStyleKit

public struct SettingsView: View {
    @EnvironmentObject var store: SettingsStore
    
    var selectedTextSize: TextSize {
        store.state.selectedTextSize
    }
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MenuMainHeader("Settings")
            
            VStack(alignment: .leading, spacing: 20) {
                textSizeSection
            }
        }
        .background(PapyrusColor.background.color)
    }
    
    private var textSizeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            MenuSubheader("Text Size")
            
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
                .font(.custom("Georgia", size: size.fontSize * size.iconScale))
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
    
}
