//
//  MenuSectionDivider.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public struct MenuSectionDivider: View {
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(PapyrusColor.iconPrimary.color.opacity(0.2))
            .frame(height: 1)
            .padding(.horizontal, 20)
    }
}
