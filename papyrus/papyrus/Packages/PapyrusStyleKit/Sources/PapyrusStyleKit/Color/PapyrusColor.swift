//
//  PapyrusColor.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public enum PapyrusColor {
    case background
    case textPrimary
    
    public var color: Color {
        switch self {
        case .background:
            Color(red: 0.98, green: 0.95, blue: 0.89)
        case .textPrimary:
            Color(red: 0.3, green: 0.25, blue: 0.2)
        }
    }
}
