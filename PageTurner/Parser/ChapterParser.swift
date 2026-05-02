//
//  ChapterParser.swift
//  PageTurner
//
//  Created by Kody McNamara on 5/1/26.
//

import SwiftUI

struct ChapterParser {
    //got these online. they indicate a chapter heading in gutenberg plain text
    private static let patterns: [String] = [
        "^CHAPTER [IVXLCDM0-9]+", //CHAPTER I, CHAPTER 1
        "^Chapter [IVXLCDMivxlcdm0-9]+", //Chapter I, Chapter 1
        "^PART [IVXLCMD0-9]+", //PART I, PART 1
        "^Part [IVXLCDMivxlcdm0-9]+", //Part I, Part 1
        "^BOOK [IVXLCDM0-9]", //BOOK I
        "^[IVX}+\\.", //I.  II. III.
    ]
    
    static func parse(_ fullText: String) -> [Chapter] {
        let lines = fullText.components(separatedBy: "\n")
        
        let combined = patterns.joined(separator: "|")
        guard let regex = try? NSRegularExpression(pattern: combined, options: [.anchorsMatchLines]) else {return [wholeBookChapter(fullText)] }
        
        //find which line indexes are chapter headings
        var headingIndex: [(lineIndex: Int, title: String)] = []
        
        for (i,line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            let range = NSRange(trimmed.startIndex..., in: trimmed)
            if regex.firstMatch(in: trimmed, range: range) != nil { headingIndex.append((i,trimmed))
            }
        }
        
        guard headingIndex.count >= 2 else { return [wholeBookChapter(fullText)] }
        
        var lineOffsets: [Int]=[]
        var running=0
        for line in lines {
            lineOffsets.append(running)
            running += line.utf16.count+1 //+1 for newline
        }
        
        var chapters: [Chapter]=[]
        
        for (idx, heading) in headingIndex.enumerated() {
            let startLine = heading.lineIndex
            let endLine = idx+1<headingIndex.count ? headingIndex[idx+1].lineIndex : lines.count
            
            let content = lines[startLine ..< endLine ]
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            let charOffset = lineOffsets[startLine]
            
            chapters.append(Chapter(id: idx, title: heading.title, content: content, characterOffset: charOffset))
        }
        return chapters
    }
    
    private static func wholeBookChapter(_ text: String) -> Chapter {
        Chapter(id:0, title: "Full Text", content: text, characterOffset:0)
    }
}
