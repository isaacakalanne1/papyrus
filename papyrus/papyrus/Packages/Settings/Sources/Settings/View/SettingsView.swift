import SwiftUI
import ReduxKit

public struct SettingsView: View {
    @EnvironmentObject var store: SettingsStore
    @State private var selectedStyle: WritingStyle = .classic
    @State private var showingStylePicker = false
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            settingsHeader
            writingStyleSection
            Spacer()
        }
        .frame(width: 320)
        .background(Color(red: 0.98, green: 0.95, blue: 0.89))
        .onAppear {
            selectedStyle = store.state.selectedWritingStyle
        }
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
    
    private var writingStyleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Writing Style")
                .font(.custom("Georgia", size: 18))
                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                .padding(.horizontal)
            
            writingStyleButton
            
            if showingStylePicker {
                writingStylePicker
            }
        }
    }
    
    private var writingStyleButton: some View {
        Button(action: {
            withAnimation {
                showingStylePicker.toggle()
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedStyle.title)
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                    
                    Text(selectedStyle.subtitle)
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color(red: 0.6, green: 0.55, blue: 0.5))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: showingStylePicker ? "chevron.up" : "chevron.down")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
            }
            .padding()
            .background(buttonBackground)
            .padding(.horizontal)
        }
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.8, green: 0.75, blue: 0.7), lineWidth: 1)
            )
    }
    
    private var writingStylePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(WritingStyle.allCases, id: \.self) { style in
                writingStyleOptionButton(for: style)
            }
        }
        .padding(.horizontal)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    private func writingStyleOptionButton(for style: WritingStyle) -> some View {
        Button(action: {
            selectedStyle = style
            store.dispatch(SettingsAction.selectWritingStyle(style))
            withAnimation {
                showingStylePicker = false
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(style.title)
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(titleColor(for: style))
                    
                    Text(style.subtitle)
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color(red: 0.6, green: 0.55, blue: 0.5))
                        .lineLimit(2)
                }
                
                Spacer()
                
                if style == selectedStyle {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.8, green: 0.65, blue: 0.4))
                }
            }
            .padding()
            .background(optionBackground(for: style))
        }
    }
    
    private func titleColor(for style: WritingStyle) -> Color {
        style == selectedStyle ? 
            Color(red: 0.8, green: 0.65, blue: 0.4) : 
            Color(red: 0.3, green: 0.25, blue: 0.2)
    }
    
    private func optionBackground(for style: WritingStyle) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(style == selectedStyle ? 
                  Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.8) : 
                  Color.clear)
    }
}