//
//  MenuButton.swift
//  PapyrusStyleKit
//

import SwiftUI

public struct MenuButton: View {
    let type: MenuButtonType
    let isEnabled: Bool
    let action: () -> Void

    public init(
        type: MenuButtonType,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: type.icon)
                .font(.system(size: type.size, weight: type.weight))
                .foregroundColor(
                    isEnabled
                    ? type.color
                    : PapyrusColor.iconPrimary.color.opacity(0.3)
                )
                .frame(width: type.frameSize, height: type.frameSize)
        }
        .disabled(!isEnabled)
    }
}
