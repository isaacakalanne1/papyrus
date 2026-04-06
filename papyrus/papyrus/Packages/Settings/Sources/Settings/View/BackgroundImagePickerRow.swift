import SwiftUI
import PhotosUI
import PapyrusStyleKit

struct BackgroundImagePickerRow: View {
    @EnvironmentObject var store: SettingsStore
    @Environment(\.papyrusColorScheme) private var colorScheme

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var pickedImage: UIImage? = nil
    @State private var isCropViewPresented = false
    @State private var isContextPickerPresented = false
    @State private var showDeleteConfirmation = false

    var selectedFontName: String { store.state.selectedFontName }
    var selectedTextSize: TextSize { store.state.selectedTextSize }

    var thumbnailImage: UIImage? {
        guard let data = store.state.backgroundImageData else { return nil }
        return UIImage(data: data)
    }

    var body: some View {
        Group {
            if let thumbnail = thumbnailImage {
                existingImageRow(thumbnail: thumbnail)
            } else {
                uploadRow
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                guard let newItem,
                      let data = try? await newItem.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                pickedImage = uiImage
                isCropViewPresented = true
                selectedItem = nil
            }
        }
        .sheet(isPresented: $isCropViewPresented) {
            if let image = pickedImage {
                ImageCropView(image: image, isPresented: $isCropViewPresented) { croppedData in
                    store.dispatch(.uploadBackgroundImage(croppedData))
                    isContextPickerPresented = true
                }
            }
        }
        .sheet(isPresented: $isContextPickerPresented) {
            BackgroundImageContextPickerSheet(
                isPresented: $isContextPickerPresented,
                initialUsage: store.state.backgroundImageUsage
            )
            .environmentObject(store)
            .environment(\.papyrusColorScheme, colorScheme)
        }
        .confirmationDialog(
            "Are you sure you want to delete the background image?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                store.dispatch(.confirmDeleteBackgroundImage)
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func existingImageRow(thumbnail: UIImage) -> some View {
        HStack(spacing: 12) {
            Image(uiImage: thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
                )

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Upload new image")
                    .font(.custom(selectedFontName, size: selectedTextSize.fontSize))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
            }

            Spacer()

            Button {
                showDeleteConfirmation = true
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                    .font(.system(size: 20))
            }
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }

    private var uploadRow: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            HStack {
                Image(systemName: "photo.badge.plus")
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                Text("Upload Image")
                    .font(.custom(selectedFontName, size: selectedTextSize.fontSize))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                Spacer()
            }
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }
}
