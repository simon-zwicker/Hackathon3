//
//  Network.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import Foundation
import Mammut

struct Network {

    static private var ombd: Mammut {
        Mammut(components: NetworkEnv.ombd.components, loglevel: .debugCurl)
    }

    static private var tmdb: Mammut {
        Mammut(components: NetworkEnv.tmdb.components, loglevel: .debugCurl)
    }
    
    static private var pock: Mammut {
        Mammut(components: NetworkEnv.pock.components, loglevel: .debugCurl)
    }

    static func request<T: Codable>(
        _ T: T.Type,
        environment: NetworkEnv,
        endpoint: Endpoint
    ) async throws -> T {
        let result = await req(T.self, endpoint, environment )
        switch result {
        case .success(let success): return success
        case .failure(let failure): throw failure.self
        }
    }

    static private func req<T: Codable>(
        _ T: T.Type,
        _ endpoint: Endpoint,
        _ env: NetworkEnv
    ) async -> Result<T, Error> {
        switch env {
        case .ombd:
            return await ombd.request(endpoint, error: ErrorObj.self)
        case .tmdb:
            return await tmdb.request(endpoint, error: ErrorObj.self)
        case .pock:
            return await pock.request(endpoint, error: ErrorObj.self)
        }
    }
}
