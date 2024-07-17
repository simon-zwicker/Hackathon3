//
//  NetworkEnv.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import Foundation

enum NetworkEnv {
    case unknown1
    case unknown2
}

extension NetworkEnv {
    var scheme: String {
        switch self {
        case .unknown1: "https"
        case .unknown2: "https"
        }
    }

    var host: String {
        switch self {
        case .unknown1: ""
        case .unknown2: ""
        }
    }

    var path: String {
        switch self {
        case .unknown1: ""
        case .unknown2: ""
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
