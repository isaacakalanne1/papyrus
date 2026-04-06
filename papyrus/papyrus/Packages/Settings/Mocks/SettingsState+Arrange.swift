//
//  SettingsState+Arrange.swift
//  Settings
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Settings
import PapyrusStyleKit

public extension SettingsState {
    static var arrange: SettingsState {
        arrange()
    }

    static func arrange(
        selectedTextSize: TextSize = .medium,
        isSubscribed: Bool = false,
        selectedFontName: String = "Georgia",
        selectedColorSchemeName: PapyrusColorSchemeName = .parchment,
        backgroundImageData: Data? = nil,
        backgroundImageUsage: Set<BackgroundImageContext> = []
    ) -> SettingsState {
        .init(
            selectedTextSize: selectedTextSize,
            isSubscribed: isSubscribed,
            selectedFontName: selectedFontName,
            selectedColorSchemeName: selectedColorSchemeName,
            backgroundImageData: backgroundImageData,
            backgroundImageUsage: backgroundImageUsage
        )
    }
}
