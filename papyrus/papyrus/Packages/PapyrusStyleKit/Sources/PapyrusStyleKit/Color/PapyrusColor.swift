//
//  PapyrusColor.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public enum PapyrusColor {
    case background
    
    public var color: Color {
        switch self {
        case .background:
            Color(red: 0.98, green: 0.95, blue: 0.89)
        }
    }
}
