//
//  APIEndpoint.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import Mammut

// MARK: - API Endpoint
enum OMDB {
    case byTitle(String)
    case byTitleArray(String)
    case byIdIMDB(String)
}

// MARK: - API Definitions
extension OMDB: Endpoint {

    // MARK: - Path
    var path: String {
        switch self {
        case .byTitle: ""
        case .byIdIMDB: ""
        case .byTitleArray: ""
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
        switch self {
        case .byTitle(let string):
            parameters["t"] = string
        case .byTitleArray(let string):
            parameters["s"] = string
        case .byIdIMDB(let string):
            parameters["i"] = string
        }
        parameters["apikey"] = NetworkEnv.ombd.apiKey
        return parameters
    }

    // MARK: - Encoding
    var encoding: Encoding {
        .url
    }
}
