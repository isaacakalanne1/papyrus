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
        .frame(width: 320)
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
                .stroke(Color(red: 0.8, green: 0.75, blue: 0.7), lineWidth: 1)
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
                    Color(red: 0.8, green: 0.65, blue: 0.4) : 
                    PapyrusColor.textSecondary.color)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    Group {
                        if size == selectedTextSize {
                            Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.8)
                        } else {
                            Color.clear
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}
