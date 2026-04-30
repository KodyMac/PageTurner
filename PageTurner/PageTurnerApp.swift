//
//  PageTurnerApp.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/29/26.
//

import SwiftUI

@main
struct PageTurnerApp: App {
    
    //creating stores
    @StateObject private var bookStore = BookStore()
    @StateObject private var libraryStore = LibraryStore()
    @StateObject private var bookmarkStore = BookmarkStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookStore)
                .environmentObject(libraryStore)
                .environmentObject(bookmarkStore)
        }
    }
}
