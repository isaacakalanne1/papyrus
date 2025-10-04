//
//  SettingsState+Arrange.swift
//  Settings
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Settings

public extension SettingsState {
    static var arrange: SettingsState {
        arrange()
    }
    
    static func arrange(
        selectedTextSize: TextSize = .medium,
        isSubscribed: Bool = false
    ) -> SettingsState {
        .init(
            selectedTextSize: selectedTextSize,
            isSubscribed: isSubscribed
        )
    }
}
