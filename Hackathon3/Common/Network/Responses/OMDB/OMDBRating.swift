//
//  MovieRating.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

struct OMDBRating: Codable {
    let source, value: String?

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
