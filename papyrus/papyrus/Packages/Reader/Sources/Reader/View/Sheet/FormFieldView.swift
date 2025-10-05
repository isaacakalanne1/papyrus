import SwiftUI
import PapyrusStyleKit

struct FormFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let focusedField: FocusState<ReaderView.Field?>.Binding
    let fieldValue: ReaderView.Field
    let onSubmit: (() -> Void)?
    
    init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        focusedField: FocusState<ReaderView.Field?>.Binding,
        fieldValue: ReaderView.Field,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.focusedField = focusedField
        self.fieldValue = fieldValue
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Georgia", size: 14))
                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
            
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
                    .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.1))
            }
            .submitLabel(.return)
            .onSubmit {
                onSubmit?()
            }
        }
    }
}
