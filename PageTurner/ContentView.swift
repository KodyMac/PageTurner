//
//  ContentView.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "books.vertical")
            }
            .tag(0)
            
            NavigationStack {
                LibraryView()
            }
            .tabItem {
                Label("Library", systemImage: "bookmark.fill")
            }
            .tag(1)
            
            NavigationStack {
                BookmarksView()
            }
            .tabItem {
                Label("Bookmarks", systemImage: "text.quote")
            }
            .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BookStore())
        .environmentObject(LibraryStore())
        .environmentObject(BookmarkStore())
}
