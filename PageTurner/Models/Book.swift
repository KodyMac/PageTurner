//
//  Book.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

struct Author: Codable, Hashable {
    let name: String
    let birthYear: Int?
    let deathYear: Int?
    
    enum CodingKeys: String, CodingKey { //i prefer camelCase :)
        case name
        case birthYear = "birth_year"
        case deathYear = "death_year"
    }
}

struct Book: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let authors: [Author]
    let subjects: [String]
    let downloadCount: Int
    let formats: [String: String] //from MIME to URL
    
    //MARK: Helpers ----
    var coverURL: URL? {
        formats["image/jpeg"].flatMap { URL(string: $0)}
    }
    var textURL: URL? {
        //use utf8 plain text, default to plain text
        let preferred = ["text/plain; charset=utf-8", "text/plain"]
        return preferred.compactMap { formats[$0] }
            .compactMap { URL(string: $0)}
            .first
    }
    var authorNames: String {
        authors.map(\.name).joined(separator: ", ")
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, authors, subjects, formats
        case downloadCount = "download_count"
    }
}

//api response wrapper
struct GutenbergResponse: Codable {
    let count: Int
    let next: String? //url to next page
    let results: [Book]
}
