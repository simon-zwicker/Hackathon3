//
//  Network.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import Foundation
import Mammut

struct Network {

    static private var api: Mammut {
        Mammut(components: NetworkEnv.unknown1.components, loglevel: .debug)
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
        case .unknown1, .unknown2:
            return await api.request(endpoint, error: ErrorObj.self)
        }
    }
}
