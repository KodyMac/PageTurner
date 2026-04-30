//
//  LibraryStore.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI
import Combine

class LibraryStore: ObservableObject {
    //all saved books
    @Published var entries: [LibraryEntry]=[]
    //reader settings
    @Published var settings: ReaderSettings = ReaderSettings()
    
    init() { load() }
    
    //MARK: - Library
    func add(_ book: Book) {
        guard !contains(book) else {return}
        entries.append(LibraryEntry(book:book))
        save()
    }
    
    func remove(_ book: Book) {
        entries.removeAll{$0.id == book.id}
        save()
    }
    
    func contains(_ book: Book) -> Bool {
        entries.contains { $0.id==book.id}
    }
    
    //download text to cache to not have to keep fetching
    func cacheText(_ text: String, for bookID: Int) {
        guard let i = entries.firstIndex(where: { $0.id==bookID}) else {return}
        entries[i].cachedText=text
        save()
    }
    
    //call from readerview as user scrolls
    func updateProgress(_ progress: ReadingProgress, for bookID: Int) {
        guard let i = entries.firstIndex(where: { $0.id == bookID }) else {return}
        entries[i].progress=progress
        save()
    }
    
    //MARK: - Settings
    func saveSettings(_ s: ReaderSettings) {
        settings = s
        PersistenceService.save(s,key:PersistenceService.Key.readerSettings)
    }
    
    //MARK: - Private Funcs
    private func save() {
        PersistenceService.save(entries,key: PersistenceService.Key.library)
    }
    
    private func load() {
        entries = PersistenceService.load([LibraryEntry].self, key: PersistenceService.Key.library) ?? []
        settings = PersistenceService.load(ReaderSettings.self, key: PersistenceService.Key.readerSettings) ?? ReaderSettings()
    }
}
