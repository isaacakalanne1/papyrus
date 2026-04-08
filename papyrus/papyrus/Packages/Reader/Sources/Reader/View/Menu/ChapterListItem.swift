//
//  ChapterListItem.swift
//  Reader
//
//  Created by Isaac Akalanne on 20/03/2026.
//

import PapyrusStyleKit
import SwiftUI
import TextGeneration

struct ChapterListItem: View {
    let chapter: Chapter
    let fontName: String
    let onTap: () -> Void

    @Environment(\.papyrusColorScheme) private var colorScheme

    var body: some View {
        Button(action: onTap) {
            Text(chapter.firstLine)
                .font(.custom(fontName, size: 14))
                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
