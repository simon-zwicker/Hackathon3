//
//  Profile.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

struct Profile: Codable {
    var id: String
    var sex: String
    var location: String
    var name: String
}

extension Profile {
    static func create(_ username: String, gender: Gender, location: String) async -> String? {
        guard let res = try? await Network.request(Profile.self, environment: .pock, endpoint: Pockethost.createProfile(username, gender.dbName, location)) else { return nil }
        return res.id
    }
}
