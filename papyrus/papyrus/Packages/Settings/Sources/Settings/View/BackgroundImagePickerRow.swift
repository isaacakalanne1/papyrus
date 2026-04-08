import PapyrusStyleKit
import PhotosUI
import SwiftUI

private let thumbnailSize: CGFloat = 76

struct BackgroundImagePickerRow: View {
    @EnvironmentObject var store: SettingsStore
    @Environment(\.papyrusColorScheme) private var colorScheme

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var pickedImage: UIImage? = nil
    @State private var isCropViewPresented = false
    @State private var isContextPickerPresented = false
    @State private var contextPickerInitialUsage: Set<BackgroundImageContext> = []
    @State private var deletingId: UUID? = nil
    @State private var isDeleteDialogPresented = false

    var selectedFontName: String { store.state.selectedFontName }
    var backgroundImages: [BackgroundImageEntry] { store.state.backgroundImages }
    var selectedId: UUID? { store.state.selectedBackgroundImageId }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(backgroundImages) { entry in
                    thumbnailButton(for: entry)
                }
                uploadButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
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
        .fullScreenCover(isPresented: $isCropViewPresented) {
            if let image = pickedImage {
                ImageCropView(image: image, isPresented: $isCropViewPresented) { croppedData in
                    let entry = BackgroundImageEntry(imageData: croppedData)
                    store.dispatch(.addBackgroundImage(entry))
                    contextPickerInitialUsage = Set(BackgroundImageContext.allCases)
                    isContextPickerPresented = true
                }
            }
        }
        .sheet(isPresented: $isContextPickerPresented) {
            BackgroundImageContextPickerSheet(
                isPresented: $isContextPickerPresented,
                initialUsage: contextPickerInitialUsage
            )
            .environmentObject(store)
            .environment(\.papyrusColorScheme, colorScheme)
        }
        .confirmationDialog(
            "Are you sure you want to delete this background image?",
            isPresented: $isDeleteDialogPresented,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let id = deletingId {
                    store.dispatch(.deleteBackgroundImage(id))
                }
                deletingId = nil
            }
            Button("Cancel", role: .cancel) { deletingId = nil }
        }
    }

    private func thumbnailButton(for entry: BackgroundImageEntry) -> some View {
        let isSelected = selectedId == entry.id
        let uiImage = UIImage(data: entry.imageData)

        return ZStack(alignment: .topTrailing) {
            Button {
                store.dispatch(.selectBackgroundImage(isSelected ? nil : entry.id))
            } label: {
                Group {
                    if let img = uiImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    } else {
                        PapyrusColor.backgroundSecondary.color(in: colorScheme)
                    }
                }
                .frame(width: thumbnailSize, height: thumbnailSize)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isSelected
                                ? PapyrusColor.accent.color(in: colorScheme)
                                : PapyrusColor.borderSecondary.color(in: colorScheme),
                            lineWidth: isSelected ? 2.5 : 1
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())

            // Delete button (top-right)
            Button {
                deletingId = entry.id
                isDeleteDialogPresented = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 22, height: 22)
                    Image(systemName: "xmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: 6, y: -6)
        }
    }

    private var uploadButton: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        PapyrusColor.borderSecondary.color(in: colorScheme),
                        style: StrokeStyle(lineWidth: 1, dash: [5, 3])
                    )
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
            }
            .frame(width: thumbnailSize, height: thumbnailSize)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
