//
//  PersistenceService.swift
//  PageTurner
//
//  Created by Kody McNamara on 4/30/26.
//

import SwiftUI

struct PersistenceService {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    //to save any encodable under userdefault key //from online
    static func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? encoder.encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    //to load decodable value. will return nil if missing key or failure //also from online
    static func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    //keys
    enum Key {
        static let library = "library"
        static let bookmarks = "bookmarks"
        static let readerSettings = "readerSettings"
        static let searchHistory = "searchHistory"
    }
}
