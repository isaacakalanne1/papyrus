import SwiftUI

struct PapyrusBackgroundImageKey: EnvironmentKey {
    static let defaultValue: (image: Image?, usage: Set<BackgroundImageContext>) = (nil, [])
}

public extension EnvironmentValues {
    var papyrusBackgroundImage: (image: Image?, usage: Set<BackgroundImageContext>) {
        get { self[PapyrusBackgroundImageKey.self] }
        set { self[PapyrusBackgroundImageKey.self] = newValue }
    }
}
