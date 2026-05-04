//
//  NoteEditorSheet.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/4/26.
//

import SwiftUI

struct NoteEditorSheet: View {
    let bookmark: Bookmark
    @EnvironmentObject var bookmarkStore: BookmarkStore
    @Environment(\.dismiss) var dismiss
    
    @State private var noteText: String
    
    init(bookmark: Bookmark) {
        self.bookmark = bookmark
        _noteText = State(initialValue: bookmark.note ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Chapter") {
                    Text(bookmark.chapterTitle)
                        .foregroundStyle(.secondary)
                }
                
                Section("Passage") {
                    Text(bookmark.passage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(4)
                }
                
                Section("Your Note") {
                    TextField("Write a note about this passage...", text: $noteText, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        bookmarkStore.updateNote(noteText, for: bookmark.id)
                        dismiss()
                    }
                    .bold()
                    .disabled(noteText == (bookmark.note ?? ""))
                }
            }
        }
        .presentationDetents([.medium]) //lock sheet to half screen
    }
}
