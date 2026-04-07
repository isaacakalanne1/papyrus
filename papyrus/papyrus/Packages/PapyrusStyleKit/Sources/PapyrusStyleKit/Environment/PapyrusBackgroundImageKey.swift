import SwiftUI

struct PapyrusBackgroundImageKey: EnvironmentKey {
    static let defaultValue: (image: Image?, usage: Set<BackgroundImageContext>) = (nil, [])
}

extension EnvironmentValues {
    public var papyrusBackgroundImage: (image: Image?, usage: Set<BackgroundImageContext>) {
        get { self[PapyrusBackgroundImageKey.self] }
        set { self[PapyrusBackgroundImageKey.self] = newValue }
    }
}
