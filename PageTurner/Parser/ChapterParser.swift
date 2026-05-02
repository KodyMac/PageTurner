//
//  ChapterParser.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/1/26.
//

import SwiftUI

struct ChapterParser {
    private static let patterns: [String] = [
        "^Chapter \\d+$", //Chapter 1, Chapter 2
        "^CHAPTER \\d+$",
        "^Chapter [IVXLCDM]+$",
        "^CHAPTER [IVXLCDM]+$",
        "^Letter \\d+$",
        "^LETTER\\d+$",
        "^Part \\d+$",
        "^PART \\d+$",
        "^Volume \\d+$",
        "^VOLUME \\d+$",
    ]
    
    static func parse(_ fullText: String) -> [Chapter] {
        let lines = fullText.components(separatedBy: "\n")
        
        let combined = patterns.joined(separator: "|")
        guard let regex = try? NSRegularExpression(pattern: combined, options: []) else {return [wholeBookChapter(fullText)] }
        
        //make cumulative line offsets
        var lineOffsets: [Int] = []
        var running = 0
        for line in lines {
            lineOffsets.append(running)
            running += line.utf16.count + 1
        }
        
        var headingIndex: [(lineIndex: Int, title: String)] = []
        
        for (i,line) in lines.enumerated() {
            guard i > 100 else { continue } //skip toc at top of file
            let trimmed = line.trimmingCharacters(in:.whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            let range = NSRange(trimmed.startIndex..., in: trimmed)
            if regex.firstMatch(in: trimmed, range: range) != nil {
                headingIndex.append((i,trimmed))
            }
        }
        guard headingIndex.count >= 2 else {
            return [wholeBookChapter(fullText)]
        }
        
        //cut into chapters
        var chapters: [Chapter] = []
        for (idx, heading) in headingIndex.enumerated() {
            let startLine = heading.lineIndex
            let endLine = idx + 1 < headingIndex.count ? headingIndex[idx + 1].lineIndex : lines.count
            
            let content = lines[startLine ..< endLine]
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            chapters.append(Chapter(id: idx, title: heading.title, content: content, characterOffset: lineOffsets[startLine]))
        }
        return chapters
    }
    private static func wholeBookChapter(_ text: String) -> Chapter {
        Chapter(id: 0, title: "Full Text", content: text, characterOffset: 0)
    }
}
