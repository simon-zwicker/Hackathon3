//
//  File.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import Mammut
import CoreLocation

enum Pockethost {
    case getProfiles
    case createProfile(String, String, String)
    case getProfile(String)
    case favourites
    case getFavourite(String)
    case createFavourite(String, String)
    case patchFavourite(String, String, String)
}

// MARK: - API Definitions
extension Pockethost: Endpoint {

    // MARK: - Path
    var path: String {
        switch self {
        case .getProfile(let id): "/profile/records/\(id)"
        case .createProfile, .getProfiles: "/profile/records"
        case .favourites, .createFavourite: "/favourites/records"
        case .patchFavourite(let id, _, _), .getFavourite(let id): "/favourites/records/\(id)"
        }
    }

    // MARK: - Method
    var method: MammutMethod {
        switch self {
        case .getProfiles, .getProfile, .favourites, .getFavourite: .get
        case .createProfile, .createFavourite: .post
        case .patchFavourite: .patch
        }
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
        case .createProfile(let name, let sex, let location):
            parameters["sex"] = sex
            parameters["location"] = location
            parameters["name"] = name
        case .createFavourite(let movieIDs, let profileID), .patchFavourite(_, let movieIDs, let profileID):
            parameters["movieIDtmdb"] = movieIDs
            parameters["profileID"] = profileID
        default:
            return parameters
        }
        return parameters
    }

    // MARK: - Encoding
    var encoding: Encoding {
        switch self {
        case .createProfile, .createFavourite, .patchFavourite: .json
        default: .url
        }
    }
}

