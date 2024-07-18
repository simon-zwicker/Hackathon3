//
//  TMDBMovies.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

struct TMDBMovies: Codable {
    let page: Int
    let results: [TMDBMovie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
