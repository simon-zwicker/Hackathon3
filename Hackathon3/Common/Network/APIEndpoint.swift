//
//  APIEndpoint.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import Mammut

// MARK: - API Endpoint
enum APIEndpoint {
    case blank
}

// MARK: - API Definitions
extension APIEndpoint: Endpoint {

    // MARK: - Path
    var path: String {
        switch self {
        case .blank: ""
        }
    }

    // MARK: - Method
    var method: MammutMethod {
        .get
    }

    // MARK: - Headers
    var headers: [MammutHeader] {
        var headers: [MammutHeader] = .init()
        return headers
    }

    // MARK: - Parameters
    var parameters: [String : Any] { [:] }

    // MARK: - Encoding
    var encoding: Encoding {
        .url
    }
}
