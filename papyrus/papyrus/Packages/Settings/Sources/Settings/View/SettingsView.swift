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
            Spacer()
        }
        .frame(width: 320)
        .background(Color(red: 0.98, green: 0.95, blue: 0.89))
    }
    
    private var settingsHeader: some View {
        HStack {
            Text("Settings")
                .font(.custom("Georgia", size: 28))
                .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
            
            Spacer()
        }
        .padding(.horizontal)
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
        .padding(.horizontal)
    }
    
    private func textSizeButton(for size: TextSize) -> some View {
        Button(action: {
            store.dispatch(.selectTextSize(size))
        }) {
            VStack(spacing: 4) {
                Text("A")
                    .font(.custom("Georgia", size: size.fontSize * size.iconScale))
                    .foregroundColor(size == selectedTextSize ? 
                        Color(red: 0.8, green: 0.65, blue: 0.4) : 
                        Color(red: 0.5, green: 0.45, blue: 0.4))
                
                Text(size.displayName)
                    .font(.custom("Georgia", size: 12))
                    .foregroundColor(size == selectedTextSize ? 
                        Color(red: 0.8, green: 0.65, blue: 0.4) : 
                        Color(red: 0.6, green: 0.55, blue: 0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(sizeButtonBackground(for: size))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func sizeButtonBackground(for size: TextSize) -> some View {
        ZStack {
            if size == selectedTextSize {
                RoundedRectangle(cornerRadius: size == .small ? 12 : 0)
                    .fill(Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.8))
                RoundedRectangle(cornerRadius: size == .small ? 12 : 0)
                    .stroke(Color(red: 0.8, green: 0.75, blue: 0.7), lineWidth: 1)
            }
        }
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: size == .small ? 12 : 0,
                bottomLeadingRadius: size == .small ? 12 : 0,
                bottomTrailingRadius: size == .extraLarge ? 12 : 0,
                topTrailingRadius: size == .extraLarge ? 12 : 0
            )
        )
    }
}
