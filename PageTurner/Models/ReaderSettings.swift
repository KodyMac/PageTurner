//
//  ReaderSettings.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

enum ReaderTheme: String, Codable, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case sepia = "Sepia"
}

enum FontChoice: String, Codable, CaseIterable {
    case system = "System"
    case serif = "Georgia"
    case mono = "Courier New"
    case comicSans = "Comic Sans"
    
    var fontName: String {
        switch self {
        case .system: return ""
        case .serif: return "Georgia"
        case .mono: return "Courier New"
        case .comicSans: return "Comic Sans MS"
        }
    }
}


struct ReaderSettings: Codable {
    var fontSize: Double = 17
    var lineSapcing: Double = 8
    var fontChoice: FontChoice = .serif
    var theme: ReaderTheme = .light
}
