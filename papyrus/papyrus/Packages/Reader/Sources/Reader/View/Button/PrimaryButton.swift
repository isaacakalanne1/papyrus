//
//  PrimaryButton.swift
//  Reader
//
//  Created by Isaac Akalanne on 28/09/2025.
//

import SwiftUI
import PapyrusStyleKit

enum PrimaryButtonSize {
    case large
    case medium
    
    var fontSize: CGFloat {
        switch self {
        case .large: return 20
        case .medium: return 18
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .large: return 20
        case .medium: return 18
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .large: return 40
        case .medium: return 36
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .large: return 20
        case .medium: return 18
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large: return 14
        case .medium: return 12
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .large: return 6
        case .medium: return 4
        }
    }
    
    var shadowOffset: (x: CGFloat, y: CGFloat) {
        switch self {
        case .large: return (0, 3)
        case .medium: return (0, 2)
        }
    }
}

struct PrimaryButton: View {
    let type: PrimaryButtonType
    let size: PrimaryButtonSize
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        type: PrimaryButtonType,
        size: PrimaryButtonSize = .large,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.size = size
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.system(size: size.iconSize))
                Text(type.title)
                    .font(.custom("Georgia", size: size.fontSize))
                    .fontWeight(.medium)
            }
            .foregroundColor(PapyrusColor.background.color)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.buttonGradientTop.color,
                                PapyrusColor.buttonGradientBottom.color
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(isDisabled ? 0.6 : 1.0)
                    .shadow(
                        color: Color.black.opacity(0.2),
                        radius: size.shadowRadius,
                        x: size.shadowOffset.x,
                        y: size.shadowOffset.y
                    )
            )
        }
        .disabled(isDisabled)
        .scaleEffect(isDisabled ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isDisabled)
    }
}
