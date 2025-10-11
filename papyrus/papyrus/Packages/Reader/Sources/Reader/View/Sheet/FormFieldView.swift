import SwiftUI
import PapyrusStyleKit

struct FormFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let focusedField: FocusState<ReaderView.Field?>.Binding
    let showHint: Bool
    let hintText: String?
    let onSubmit: (() -> Void)?
    @State private var pulseAnimation = false
    
    init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        focusedField: FocusState<ReaderView.Field?>.Binding,
        showHint: Bool = false,
        hintText: String? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.focusedField = focusedField
        self.showHint = showHint
        self.hintText = hintText
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Georgia", size: 14))
                .foregroundColor(PapyrusColor.textSecondary.color)
            
            TextField(
                placeholder,
                text: $text,
                axis: .vertical
            )
            .font(.custom("Georgia", size: 16))
            .foregroundColor(PapyrusColor.textPrimary.color)
            .lineLimit(3, reservesSpace: true)
            .padding(12)
            .background {
                ZStack {
                    // Normal background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(PapyrusColor.iconPrimary.color.opacity(0.1))
                    
                    // Hint glow effect
                    if showHint {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        PapyrusColor.textSecondary.color.opacity(0.4),
                                        PapyrusColor.textSecondary.color.opacity(0.6)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 2
                            )
                            .scaleEffect(pulseAnimation ? 1.02 : 1.0)
                            .opacity(pulseAnimation ? 0.8 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.8).repeatWhile(showHint, autoreverses: true),
                                value: pulseAnimation
                            )
                    }
                }
            }
            .submitLabel(.return)
            .onSubmit {
                onSubmit?()
            }
            
            // Hint text
            if showHint, let hintText = hintText {
                Text(hintText)
                    .font(.custom("Georgia", size: 13))
                    .foregroundColor(PapyrusColor.textSecondary.color.opacity(0.8))
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity
                    ))
                    .animation(.easeInOut(duration: 0.3), value: showHint)
            }
        }
        .onChange(of: showHint) { oldValue, newValue in
            if newValue {
                pulseAnimation = true
            } else {
                pulseAnimation = false
            }
        }
    }
}

// Helper extension for repeating animations
extension Animation {
    func repeatWhile(_ condition: Bool, autoreverses: Bool = true) -> Animation {
        condition ? self.repeatForever(autoreverses: autoreverses) : self
    }
}
