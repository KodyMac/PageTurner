//
//  DiscoverView.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

struct DiscoverView: View {
    
    @EnvironmentObject var bookStore: BookStore
    @EnvironmentObject var libraryStore: LibraryStore
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        Group {
            if bookStore.isLoading && bookStore.results.isEmpty {
                //do the little spinning loading thing
                ProgressView("Loading books...")
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
            } else if let error = bookStore.errorMessage {
                ContentUnavailableView("Couldn't load books.", systemImage: "wifi.slash", description: Text(error))
            } else {
                bookList
            }
        }
        .navigationTitle("Discover")
        .searchable(text: $searchText, isPresented: $isSearching, prompt: "Search books or authors")
        .onSubmit(of: .search) {
            Task { await bookStore.search(query: searchText) }
        }
        .onChange(of:searchText) { _, newValue in
            //clear search so go back to popular books
            if newValue.isEmpty {
                Task { await bookStore.search(query: "")}
            }
        }
    }
    
    //MARK: - Book list
    
    private var bookList: some View {
        List {
            //show history when search bar active
            if isSearching && searchText.isEmpty && !bookStore.searchHistory.isEmpty {
                Section("Recent Searches") {
                    ForEach(bookStore.searchHistory, id: \.self) { term in
                        Button {
                            searchText = term
                            Task { await bookStore.search(query: term) }
                        } label: {
                            Label(term, systemImage: "clock")
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            
            //results
            Section(bookStore.results.isEmpty ? "" : searchText.isEmpty ? "Popular Books" : "Results") {
                ForEach(bookStore.results) { book in
                    NavigationLink(value:book) {
                        BookCard(book: book)
                    }
                    //load more when last item is shown
                    .onAppear {
                        if book.id == bookStore.results.last?.id {
                            Task { await bookStore.loadNextPage() }
                        }
                    }
                }
                //spinny thing
                if bookStore.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .navigationDestination(for: Book.self) { book in BookDetailView(book:book)
        }
    }
}

#Preview {
    NavigationStack {
        DiscoverView()
    }
    .environmentObject(BookStore())
    .environmentObject(LibraryStore())
}
