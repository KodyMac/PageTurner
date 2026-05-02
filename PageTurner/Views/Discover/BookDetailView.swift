//
//  BookDetailView.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/1/26.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var bookmarkStore: BookmarkStore
    
    @State private var chapters: [Chapter]=[]
    @State private var isLoadingText = false
    @State private var loadError: String? = nil
    
    @State private var selectedChapter: Chapter? = nil
    
    var inLibrary: Bool { libraryStore.contains(book) }
    
    var body: some View {
        List {
            //header part with cover and metadata
            Section {
                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: book.coverURL) {phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                        default:
                            Rectangle().foregroundStyle(.secondary.opacity(0.15))
                                .overlay { Image(systemName: "book.closed")
                                    .foregroundStyle(.secondary) }
                        }
                    }
                    .frame(width: 90, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.2), radius: 6, x:0, y:3)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(book.title)
                            .font(.title3).bold()
                            .fixedSize(horizontal: false, vertical: true)
                        Text(book.authorNames)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(book.downloadCount.formatted()) downloads")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.vertical, 8)
            }
            
            //library and read buttons
            Section {
                Button {
                    inLibrary ? libraryStore.remove(book) : libraryStore.add(book)
                } label: {
                    Label(inLibrary ? "Remove from Library": "Add to Library", systemImage: inLibrary ? "minus.circle":"plus.circle.fill")
                        .foregroundStyle(inLibrary ? .red : .blue)
                }
                if inLibrary {
                    Button {
                        //start from saved part
                        let savedIndex = libraryStore.entries
                            .first { $0.id == book.id }?.progress.chapterIndex ?? 0
                        if !chapters.isEmpty {
                            selectedChapter = chapters[min(savedIndex, chapters.count - 1)]
                        }
                    } label: {
                        Label("Continue Reading", systemImage: "book.fill")
                    }
                    .disabled(chapters.isEmpty)
                }
            }
            
            //subjects and genres
            if !book.subjects.isEmpty {
                Section("Subjects") {
                    Text(book.subjects.prefix(5).joined(separator: " - "))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            //chapter list
            Section("Chapters") {
                if isLoadingText {
                    HStack {
                        ProgressView()
                        Text("Downloading book...")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                } else if let error = loadError {
                    Text(error).foregroundStyle(.red).font(.subheadline)
                } else {
                    ForEach(chapters) { chapter in ChapterRow(chapter: chapter)
                            .onTapGesture { selectedChapter = chapter }
                    }
                }
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadText() }
        .navigationDestination(isPresented: .init(
            get: { selectedChapter != nil },
            set: {if !$0 { selectedChapter = nil }}
        )) {
            if let chapter = selectedChapter {
                ReaderView(book: book, chapters: chapters, startingChapter: chapter)
            }
        }
    }
    
    //MARK: - load and parse text
    
    private func loadText() async {
        //use cached text if can
        if let cached = libraryStore.entries
            .first(where: { $0.id == book.id })?.cachedText {
            chapters = ChapterParser.parse(cached)
            return
        }
        
//        print("Text URL: \(book.textURL?.absoluteString ?? "NIL")")
//        print("All formats: \(book.formats)")
        guard let url = book.textURL else {
            loadError = "No plain text available for this book."
            return
        }
        
        isLoadingText = true
        do {
            let (data, _) = try await URLSession.shared.data(from:url)
            if let text = String(data: data, encoding: .utf8) ?? String(data:data, encoding:.isoLatin1) {
                chapters = ChapterParser.parse(text)
                //cache for offline use
                libraryStore.cacheText(text, for:book.id)
            } else {
                loadError = "Could not read book text."
            }
        } catch {
            loadError = "Failed to download book."
        }
        isLoadingText = false
    }
}
