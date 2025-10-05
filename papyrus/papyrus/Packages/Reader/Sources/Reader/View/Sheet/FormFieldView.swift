import SwiftUI
import PapyrusStyleKit

struct FormFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let focusedField: FocusState<ReaderView.Field?>.Binding
    let onSubmit: (() -> Void)?
    
    init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        focusedField: FocusState<ReaderView.Field?>.Binding,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.focusedField = focusedField
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
                RoundedRectangle(cornerRadius: 8)
                    .fill(PapyrusColor.iconPrimary.color.opacity(0.1))
            }
            .submitLabel(.return)
            .onSubmit {
                onSubmit?()
            }
        }
    }
}
