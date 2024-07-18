//
//  OMDBMovies.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

struct OMDBMovies: Codable {
    let search: [OMDBMovie]?
    let totalResults, response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}
