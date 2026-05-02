//
//  Bookmark.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

struct Bookmark: Codable, Identifiable {
    let id: UUID
    var bookID: Int
    var bookTitle: String
    var chapterIndex: Int
    var chapterTitle: String
    var passage: String
    var note: String? //user annotations
    let createdAt: Date
    
    init(bookID: Int, bookTitle: String, chapterIndex: Int, chapterTitle: String,passage:String,note:String?=nil) {
        self.id = UUID()
        self.bookID = bookID
        self.bookTitle = bookTitle
        self.chapterTitle = chapterTitle
        self.chapterIndex = chapterIndex
        self.passage=passage
        self.note = note
        self.createdAt = .now
    }
}
