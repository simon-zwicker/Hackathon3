//
//  Genres.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

enum Genre: Int, CaseIterable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case drama = 18
    case fantasy = 14
    case history = 36
    case horror = 27
    case thriller = 53
    case western = 37
}

extension Genre {
    var name: String {
        switch self {
        case .action:
            "Action"
        case .adventure:
            "Abenteuer"
        case .animation:
            "Animation"
        case .comedy:
            "Comedy"
        case .crime:
            "Crime"
        case .drama:
            "Drama"
        case .fantasy:
            "Fantasy"
        case .history:
            "History"
        case .horror:
            "Horror"
        case .thriller:
            "Thriller"
        case .western:
            "Western"
        }
    }
}
