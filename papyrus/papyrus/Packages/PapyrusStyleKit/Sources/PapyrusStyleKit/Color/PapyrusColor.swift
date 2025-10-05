//
//  PapyrusColor.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

enum PapyrusColor {
    case background
    
    var color: Color {
        switch self {
        case .background:
            Color.red // Background color here
        }
    }
}
