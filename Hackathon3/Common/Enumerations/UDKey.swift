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
}

extension UDKey {
    var key: String {
        switch self {
        case .selectedGenre: "selectedGenre"
        case .page(let int): "page\(int)"
        case .favourised(let int): "liked\(int)"
        }
    }
    
    var value: Any {
        switch self {
        case .selectedGenre, .page:
            UserDefaults.standard.integer(forKey: self.key)
        case .favourised(let int):
            UserDefaults.standard.bool(forKey: self.key)
        }
    }
    
    func set(_ newValue: Any?) {
        UserDefaults.standard.setValue(newValue, forKey: self.key)
    }
}
