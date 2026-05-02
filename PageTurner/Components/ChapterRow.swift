//
//  ChapterRow.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/1/26.
//

import SwiftUI

struct ChapterRow: View {
    let chapter: Chapter
    var body: some View {
        HStack {
            //chapter number
            Text("\(chapter.id+1)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 28)
            
            Text(chapter.title)
                .font(.body)
                .lineLimit(1)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
    }
}
