//
//  BookmarkStore.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI
import Combine

class BookmarkStore: ObservableObject {
    @Published var bookmarks: [Bookmark] = []
    init() { load()}
    
    //add new bookmark (from readerview)
    func add(_ bookmark: Bookmark) {
        bookmarks.insert(bookmark, at: 0)
        save()
    }
    
    //remove by id
    func remove(id: UUID) {
        bookmarks.removeAll {$0.id==id}
        save()
    }
    
    //update annotation
    func updateNote(_ note: String, for id:UUID) {
        guard let i = bookmarks.firstIndex(where: {$0.id == id}) else {return}
        bookmarks[i].note=note
        save()
    }
    
    //all bookmarks for specific book
    func bookmarks(for bookID:Int) -> [Bookmark] {
        bookmarks.filter { $0.bookID == bookID}
    }
    
    //MARK: - PRivate
    private func save() {
        PersistenceService.save(bookmarks,key:PersistenceService.Key.bookmarks)
    }
    
    private func load() {
        bookmarks = PersistenceService.load([Bookmark].self, key: PersistenceService.Key.bookmarks) ?? []
    }
}
