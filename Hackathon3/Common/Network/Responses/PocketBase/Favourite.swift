//
//  FavouriteCreation.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

struct Favourite: Codable {
    var id: String
    var movieIDtmdb: String
    var profileID: String
}

extension Favourite {
    static func create(_ favs: String, profileID: String) async -> String? {
        guard let res = try? await Network.request(Favourite.self, environment: .pock, endpoint: Pockethost.createFavourite(favs, profileID)) else { return nil }
        return res.id
    }
    
    static func update(_ id: String, _ favs: String, profileID: String) async -> String? {
        guard let res = try? await Network.request(Favourite.self, environment: .pock, endpoint: Pockethost.patchFavourite(id, favs, profileID)) else { return nil }
        return res.movieIDtmdb
    }
    
    static func fetch(_ id: String) async -> Favourite? {
        return try? await Network.request(Favourite.self, environment: .pock, endpoint: Pockethost.getFavourite(id))
    }
    
    static func changeOne(movieID: Int, favourised: Bool) async -> MResult<String, StorageError> {
        guard let profileID = await getUserID() else { return .error(.userID) }
        guard let id = await Favourite.getOrCreateID(profileID: profileID) else { return .error(.favID)}
        
        guard let res = await Favourite.fetch(id)?.movieIDtmdb else { return .error(.fetch) }
        var favs: [Int] = array(res)
        
        print("\n\n before\(favs)")
        if favourised {
            favs.append(movieID)
        } else {
            favs.removeAll(where: { $0 == movieID })
        }
        
        print("\n\n after\(favs)")
        
        let unique: [String] = Array(Set(favs)).map { val in
            "\(val)"
        }
        let str = unique.joined(separator: ",")
        
        guard let update = await Favourite.update(id, str, profileID: profileID) else {
            return .error(.update)
        }
        return .ok(update)
    }
    
    static func getOrCreateID(profileID: String) async -> String? {
        guard let id = UDKey.favouritesID.value as? String else {
            return await Favourite.create("", profileID: profileID)
        }
        return id
    }
    
    static func getUserID() async -> String? {
        guard let profileID = UDKey.profileID.value as? String else {
            guard let favID = UDKey.favouritesID.value as? String else {
                return nil
            }
            return await Favourite.fetch(favID)?.profileID
        }
        return profileID
    }
    
    static func array(_ input: String) -> [Int] {
        input.split(separator: ",").compactMap({ str in
            let strID = str.trimmingCharacters(in: .whitespacesAndNewlines)
            return try? Int(strID, format: .number)
        })
    }
}
