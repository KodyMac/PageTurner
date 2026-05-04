//
//  BookmarkRow.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/4/26.
//

import SwiftUI

struct BookmarkRow: View {
    
    let bookmark: Bookmark
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            //chapter title and date
            HStack {
                Label(bookmark.chapterTitle, systemImage: "bookmark.fill")
                    .font(.subheadline.bold())
                    .foregroundStyle(.blue)
                    .lineLimit(1)
                
                Spacer()
                
                Text(bookmark.createdAt.formatted(.dateTime.month(.abbreviated).day().year()))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            //passage preview
            if let note = bookmark.note, !note.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "pencil")
                        .font(.caption2)
                    Text(note)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.vertical, 4)
    }
}
