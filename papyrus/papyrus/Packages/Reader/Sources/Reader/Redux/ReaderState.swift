//
//  ReaderState.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

public struct ReaderState: Equatable {
    var chapter: String?

    public init(
        chapter: String? = nil
    ) {
        self.chapter = chapter
    }
}
