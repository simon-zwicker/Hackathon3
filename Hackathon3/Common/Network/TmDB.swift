//
//  TmDB.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import Mammut

// MARK: - API Endpoint
enum TmDB {
    case movie(String, Int)
    case topRated
}

// MARK: - API Definitions
extension TmDB: Endpoint {

    // MARK: - Path
    var path: String {
        switch self {
        case .movie: "/discover/movie"
        case .topRated: "/movie/top_rated"
        }
    }

    // MARK: - Method
    var method: MammutMethod {
        .get
    }

    // MARK: - Headers
    var headers: [MammutHeader] {
        var headers: [MammutHeader] = .init()
        headers.append(.content(.type("application/json")))
        return headers
    }

    // MARK: - Parameters
    var parameters: [String : Any] {
        var parameters: [String: Any] = [:]
        parameters["api_key"] = NetworkEnv.tmdb.apiKey
        switch self {
        case .movie(let genreId, let page):
            parameters["page"] = "\(page)"
            parameters["with_genres"] = genreId
        default:
            return parameters
        }
        return parameters
    }

    // MARK: - Encoding
    var encoding: Encoding {
        .url
    }
}
