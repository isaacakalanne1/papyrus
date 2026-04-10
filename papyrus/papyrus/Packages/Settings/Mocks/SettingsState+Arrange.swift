//
//  SettingsState+Arrange.swift
//  Settings
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import PapyrusStyleKit
import Settings

public extension SettingsState {
    static var arrange: SettingsState {
        SettingsState.arrange()
    }

    static func arrange(
        selectedTextSize: TextSize = .medium,
        isSubscribed: Bool = false,
        perspective: StoryPerspective = .thirdPerson,
        selectedFontName: String = "Georgia",
        selectedColorSchemeName: PapyrusColorSchemeName = .parchment,
        storyMode: StoryMode = .story,
        backgroundImages: [BackgroundImageEntry] = [],
        selectedBackgroundImageId: UUID? = nil,
        backgroundImageUsage: Set<BackgroundImageContext> = [],
        sentenceCount: Int = 3
    ) -> SettingsState {
        .init(
            selectedTextSize: selectedTextSize,
            isSubscribed: isSubscribed,
            perspective: perspective,
            selectedFontName: selectedFontName,
            selectedColorSchemeName: selectedColorSchemeName,
            storyMode: storyMode,
            backgroundImages: backgroundImages,
            selectedBackgroundImageId: selectedBackgroundImageId,
            backgroundImageUsage: backgroundImageUsage,
            sentenceCount: sentenceCount
        )
    }
}
