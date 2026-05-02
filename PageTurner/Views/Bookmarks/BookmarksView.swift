//
//  BookmarksView.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//
import SwiftUI

struct BookmarksView: View {
    
    @EnvironmentObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var libraryStore: LibraryStore
    
    //group bookmarks by book title
    var grouped: [String: [Bookmark]] {
        Dictionary(grouping:bookmarkStore.bookmarks, by: \.bookTitle)
    }
    
    //sort book titles
    var sortedTitles: [String] {
        grouped.keys.sorted()
    }
    
    var body: some View {
        Group {
            if bookmarkStore.bookmarks.isEmpty {
                ContentUnavailableView("No Bookmarks yet", systemImage: "bookmark", description: Text("Tap the bookmark icon while reading to save a chapter."))
            } else {
                bookmarkList
            }
        }
        .navigationTitle("Bookmarks")
    }
    
    //MARK: - List
    
    private var bookmarkList: some View {
        List {
            ForEach(sortedTitles, id: \.self) { title in
                Section(title) {
                    ForEach(grouped[title] ?? []) { bookmark in
                        BookmarkRow(bookmark: bookmark)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    bookmarkStore.remove(id: bookmark.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    addNote(to: bookmark)
                                } label: {
                                    Lable("Note", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                }
            }
        }
    }
    
    //MARK: - Add note
    func addNote(to bookmark: Bookmark) {
        //placeholder for now
        bookmarkStore.updateNote("My note", for: bookmark.id)
    }
}
