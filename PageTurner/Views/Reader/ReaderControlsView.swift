//
//  ReaderControlsView.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/1/26.
//

import SwiftUI

struct ReaderControlsView: View {
    let book: Book
    let chapters: [Chapter]
    @Binding var currentChapter: Chapter
    @Binding var showChapterPicker: Bool
    @Binding var showBookmarkAlert: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing:0) {
                
                //prev chapter
                Button {
                    guard currentChapter.id > 0 else {return}
                    withAnimation { currentChapter = chapters[currentChapter.id - 1]}
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .disabled(currentChapter.id == 0)
                
                //chapter counter
                Button { showChapterPicker = true } label: {
                    VStack(spacing: 2) {
                        Text("Chapter")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("\(currentChapter.id + 1) of \(chapters.count)")
                            .font(.caption.monospacedDigit())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .foregroundStyle(.primary)
                
                //next chapter
                Button {
                    guard currentChapter.id < chapters.count - 1 else {return}
                    withAnimation { currentChapter = chapters[currentChapter.id + 1 ]}
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .disabled(currentChapter.id == chapters.count - 1)
                }
            .background(.regularMaterial)
        }
        .sheet(isPresented: $showChapterPicker) {
            NavigationStack {
                List(chapters) { chapter in
                    Button {
                        currentChapter = chapter
                        showChapterPicker = false
                    } label: {
                        HStack {
                            ChapterRow(chapter: chapter)
                            if chapter.id == currentChapter.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .navigationTitle("Chapters")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { showChapterPicker = false }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}
