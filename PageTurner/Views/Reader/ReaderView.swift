//
//  ReaderView.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/1/26.
//

import SwiftUI

struct ReaderView: View {
    
    let book: Book
    let chapters: [Chapter]
    let startingChapter: Chapter
    
    @EnvironmentObject var libraryStore: LibraryStore
    @EnvironmentObject var bookmarkStore: BookmarkStore
    
    @State private var currentChapter: Chapter
    @State private var showControls = true
    @State private var showChapterPicker = false
    @State private var showBookmarkAlert = false
    
    var settings: ReaderSettings { libraryStore.settings }
    
    init(book: Book, chapters: [Chapter], startingChapter: Chapter) {
        self.book = book
        self.chapters = chapters
        self.startingChapter = startingChapter
        _currentChapter = State(initialValue: startingChapter)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            settings.theme.backgroundColor
                .ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(currentChapter.title)
                            .font(.title2.bold())
                            .foregroundStyle(settings.theme.textColor)
                            .padding(.bottom, 16)
                            .id("top")
                        
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(currentChapter.content.components(separatedBy: "\n\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }, id: \.self) { paragraph in
                                Text(paragraph.trimmingCharacters(in: .whitespacesAndNewlines))
                                    .font(readerFont)
                                    .foregroundStyle(settings.theme.textColor)
                                    .lineSpacing(CGFloat(settings.lineSpacing))
                                    .textSelection(.enabled)
                            }
                        }
                    }
                    .padding(.horizontal,20)
                    .padding(.vertical, 24)
                    .padding(.bottom, 80)
                }
                .simultaneousGesture(
                    TapGesture().onEnded {
                        withAnimation { showControls.toggle() }
                    }
                )
                .onChange(of: currentChapter.id) { _, _ in
                    withAnimation { proxy.scrollTo("top", anchor: .top)}
                }
            }
            
            
            
            if showControls {
                ReaderControlsView(book:book,chapters:chapters, currentChapter: $currentChapter, showChapterPicker: $showChapterPicker, showBookmarkAlert: $showBookmarkAlert)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(currentChapter.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showBookmarkAlert = true } label: {
                    Image(systemName: "bookmark")
                }
            }
        }
        .onDisappear { saveProgress() }
        .alert("Bookmark this chapter?", isPresented: $showBookmarkAlert) {
            Button("Bookmark") { addBookmark() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Saves \"\(currentChapter.title)\" to your bookmarks.")
        }
    }
    
    //MARK: -Helpers
    
    private var readerFont: Font {
        let size = settings.fontSize
        switch settings.fontChoice {
        case .system:
            return .system(size:size)
        case .serif:
            return .custom("Georgia", size:size)
        case .mono:
            return .custom("Courier New", size:size)
        case .comicSans:
            return .custom("Comic Sans MS", size:size)
        default: return .custom(settings.fontChoice.fontName, size: size)
        }
    }
    
    private func saveProgress() {
        guard libraryStore.contains(book) else { return }
        let percent = chapters.isEmpty ? 0.0: Double(currentChapter.id) / Double(chapters.count)
        libraryStore.updateProgress(
            ReadingProgress(chapterIndex:currentChapter.id,scrollOffset:0,percentComplete: percent, lastReadAt: .now), for: book.id )
    }
    
    private func addBookmark() {
        bookmarkStore.add(Bookmark(
            bookID: book.id, bookTitle: book.title, chapterIndex: currentChapter.id,chapterTitle:currentChapter.title,passage:String(currentChapter.content.prefix(200))))
    }
}


//MARK: - Themes?
extension ReaderTheme {
    var backgroundColor: Color {
        switch self {
            //color values from online
        case .light: return .white
        case .dark: return Color(red:0.1, green:0.1, blue: 0.1)
        case .sepia: return Color(red:0.97, green: 0.93, blue: 0.84)
        }
    }
    var textColor: Color {
        switch self {
        case .light: return Color(red: 0.1, green: 0.1, blue:0.1)
        case .dark: return Color(red: 0.9, green: 0.9, blue:0.9)
        case .sepia: return Color(red:0.25, green: 0.18, blue:0.1)
        }
    }
}
