//
//  LibraryView.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

struct LibraryView: View {
    
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var bookmarkStore: BookmarkStore
    
    //which entry is being chosen
    @State private var selectedEntry: LibraryEntry?=nil
    
    var body: some View {
        Group {
            if libraryStore.entries.isEmpty {
                emptyState
            } else {
                bookList
            }
        }
        .navigationTitle("My Library")
    }
    
    //MARK: - Empty state
    private var emptyState: some View {
        ContentUnavailableView(
            "Your Library is Empty", systemImage: "books.vertical", description: Text("Visit discover and add books to start.") )
    }
    
    //MARK: - Book list
    
    private var bookList: some View {
        List {
            ForEach(libraryStore.entries) { entry in
                NavigationLink(value: entry) {
                    libraryRow(entry:entry)
                }
            }
            .onDelete {indexSet in
                indexSet.forEach { i in
                    libraryStore.remove(libraryStore.entries[i].book)
                }
            }
        }
        .navigationDestination(for: LibraryEntry.self) { entry in
            BookDetailView(book: entry.book)
        }
    }
    
    //MARK: - Row
    private func libraryRow(entry: LibraryEntry) -> some View {
        HStack(spacing:14) {
            //cover image
            AsyncImage(url: entry.book.coverURL) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Rectangle()
                        .foregroundStyle(.secondary.opacity(0.2))
                        .overlay {
                            Image(systemName: "book.closed")
                                .foregroundStyle(.secondary)
                        }
                }
            }
            .frame(width:55, height:78)
            .clipShape(RoundedRectangle(cornerRadius:6))
            .shadow(color: .black.opacity(0.15),radius:4,x:0,y:2)
            
            //title author lastRead
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.book.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(entry.book.authorNames)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Spacer()
                
                Text("Last read \(entry.progress.lastReadAt.formatted(.relative(presentation: .named)))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            //progress ring
            ProgressRing(progress: entry.progress.percentComplete)
                .frame(width:36,height:36)
        }
        .padding(.vertical, 4)
    }
}

//make sure libraryentry is hashable for the navigationlink
extension LibraryEntry: Hashable {
    static func == (lhs: LibraryEntry, rhs: LibraryEntry) -> Bool {
        lhs.id==rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
