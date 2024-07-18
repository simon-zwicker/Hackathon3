//
//  NetworkEnv.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import Foundation

enum NetworkEnv {
    case ombd
    case tmdb
}

extension NetworkEnv {
    var scheme: String {
        switch self {
        case .ombd: "https"
        case .tmdb: "https"
        }
    }

    var host: String {
        switch self {
        case .ombd: "omdbapi.com"
        case .tmdb: "api.themoviedb.org"
        }
    }

    var path: String {
        switch self {
        case .ombd: "/"
        case .tmdb: "/3"
        }
    }

    var apiKey: String {
        switch self {
        case .ombd: "7699b46"
        case .tmdb: "ff1d5a77eb312ab5e5b47384d0c5de36"
        }
    }

    var components: URLComponents {
        var comp = URLComponents()
        comp.scheme = scheme
        comp.host = host
        comp.path = path
        return comp
    }
}
