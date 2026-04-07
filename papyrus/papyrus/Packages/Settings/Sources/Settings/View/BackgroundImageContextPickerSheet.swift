import SwiftUI
import PapyrusStyleKit

struct BackgroundImageContextPickerSheet: View {
    @EnvironmentObject var store: SettingsStore
    @Environment(\.papyrusColorScheme) private var colorScheme
    @Binding var isPresented: Bool

    @State private var selectedContexts: Set<BackgroundImageContext>

    init(isPresented: Binding<Bool>, initialUsage: Set<BackgroundImageContext>) {
        self._isPresented = isPresented
        self._selectedContexts = State(initialValue: initialUsage)
    }

    var selectedFontName: String { store.state.selectedFontName }
    var selectedTextSize: TextSize { store.state.selectedTextSize }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(BackgroundImageContext.allCases, id: \.self) { context in
                        Button {
                            if selectedContexts.contains(context) {
                                selectedContexts.remove(context)
                            } else {
                                selectedContexts.insert(context)
                            }
                        } label: {
                            HStack {
                                Text(context.displayName)
                                    .font(.custom(selectedFontName, size: selectedTextSize.fontSize))
                                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                                Spacer()
                                if selectedContexts.contains(context) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(PapyrusColor.accent.color(in: colorScheme))
                                }
                            }
                        }
                        .listRowBackground(PapyrusColor.backgroundSecondary.color(in: colorScheme))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(PapyrusColor.background.color(in: colorScheme))
            }
            .background(PapyrusColor.background.color(in: colorScheme))
            .navigationTitle("Show Background In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        store.dispatch(.setBackgroundImageUsage(selectedContexts))
                        isPresented = false
                    }
                    .font(.custom(selectedFontName, size: selectedTextSize.fontSize))
                    .foregroundColor(PapyrusColor.accent.color(in: colorScheme))
                }
            }
        }
        .presentationDetents([.medium])
    }
}
