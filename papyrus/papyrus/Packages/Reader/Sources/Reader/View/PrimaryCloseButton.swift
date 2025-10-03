//
//  PrimaryCloseButton.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import SwiftUI

struct PrimaryCloseButton: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
        }
    }
}