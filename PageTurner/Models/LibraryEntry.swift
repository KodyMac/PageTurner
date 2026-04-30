//
//  LibraryEntry.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

struct ReadingProgress: Codable {
    var chapterIndex: Int = 0
    var scrollOffset: Double = 0 //fraction through the chapter
    var percentComplete: Double = 0 //progress through the entire book
    var lastReadAt: Date = .now
}

struct LibraryEntry: Codable, Identifiable {
    let book: Book //snapshot of whole book, so don't need to keep fetching
    var savedAt: Date
    var cachedText: String? //the gutenberg plaintext
    var progress: ReadingProgress
    
    var id: Int { book.id }
    
    init(book: Book) {
        self.book = book
        self.savedAt = .now
        self.progress = ReadingProgress()
    }
}
