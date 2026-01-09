import SwiftUI

private struct ReaderFocusedFieldKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: FocusState<ReaderField?>.Binding? = nil
}

extension EnvironmentValues {
    var readerFocusedField: FocusState<ReaderField?>.Binding? {
        get { self[ReaderFocusedFieldKey.self] }
        set { self[ReaderFocusedFieldKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, @ViewBuilder content: (Self, T) -> Content) -> some View {
        if let value = value {
            content(self, value)
        } else {
            self
        }
    }
}
