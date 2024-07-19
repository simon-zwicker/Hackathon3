//
//  File.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

struct FavouriteTMDBMovie: Codable {
    let id: Int
    let title: String
    let imdbID: String
    let posterPath: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, title
        case imdbID = "imdb_id"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
