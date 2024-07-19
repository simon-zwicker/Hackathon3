//
//  UDKey.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

enum UDKey {
    case selectedGenre
    case page(Int) ///Page current page for genre
    case favourised(Int)
    case favouritesID
    case profileID
}

extension UDKey {
    var key: String {
        switch self {
        case .selectedGenre: "selectedGenre"
        case .page(let int): "page\(int)"
        case .favourised(let int): "liked\(int)"
        case .favouritesID: "favouritesID"
        case .profileID: "profileID"
        }
    }
    
    var value: Any? {
        switch self {
        case .selectedGenre, .page:
            UserDefaults.standard.integer(forKey: self.key)
        case .favourised:
            UserDefaults.standard.bool(forKey: self.key)
        case.favouritesID, .profileID:
            UserDefaults.standard.string(forKey: self.key)
        }
    }
    
    func set(_ newValue: Any?) {
        UserDefaults.standard.setValue(newValue, forKey: self.key)
    }
}
