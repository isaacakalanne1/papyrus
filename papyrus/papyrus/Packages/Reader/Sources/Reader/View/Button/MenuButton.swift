//
//  MenuButton.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

struct MenuButton: View {
    let type: MenuButtonType
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        type: MenuButtonType,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
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
