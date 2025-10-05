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
            .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2))
            .frame(height: 1)
            .padding(.horizontal, 20)
    }
}
