import SwiftUI
import ReduxKit

public struct SettingsView: View {
    @EnvironmentObject var store: SettingsStore
    
    var selectedTextSize: TextSize {
        store.state.selectedTextSize
    }
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            settingsHeader
            textSizeSection
        }
        .frame(width: 320)
        .background(Color(red: 0.98, green: 0.95, blue: 0.89))
    }
    
    private var settingsHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Settings")
                .font(.custom("Georgia", size: 24))
                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
            
            Divider()
                .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.5))
        }
        .padding()
        .padding(.top, 20)
    }
    
    private var textSizeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Text Size")
                .font(.custom("Georgia", size: 18))
                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                .padding(.horizontal)
            
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
        .padding(.horizontal)
    }
    
    private func textSizeButton(for size: TextSize) -> some View {
        Button(action: {
            store.dispatch(.selectTextSize(size))
        }) {
            Text("A")
                .font(.custom("Georgia", size: size.fontSize * size.iconScale))
                .foregroundColor(size == selectedTextSize ? 
                    Color(red: 0.8, green: 0.65, blue: 0.4) : 
                    Color(red: 0.5, green: 0.45, blue: 0.4))
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
