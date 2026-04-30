//
//  Chapter.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

struct Chapter: Identifiable {
    let id: Int
    let title: String
    let content: String //full chapter
    let characterOffset: Int //position in the full book string
}
