//
//  ProfilesModel.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 19.07.24.
//

import Foundation
import SwiftUI

@Observable
class ProfilesModel {
    var profiles: [Profile] = []
    var favs: [FavouriteTMDBMovie] = []
    var favsFetchBlocked = false
    
    var userProfile: Profile? {
        profiles.first(where: { $0.id == (UDKey.profileID.value as? String) })
    }

    func fetch() async {
        do {
            let data = try await Network.request(
                PocketBase<Profile>.self,
                environment: .pock,
                endpoint: Pockethost.getProfiles
            )
            self.profiles = data.items
        } catch {
            print("Error fetching profiles: \(error.localizedDescription)")
        }
    }

    func createUser(_ name: String, _ gender: Gender) async -> Bool {
        guard 
        let profileID = await Profile.create(
            name,
            gender: gender,
            location: "49.006889,8.403653"
        ),
        let favId = await Favourite.create(
            "",
            profileID: profileID
        )
        else { return false }
        
        await fetch()
        await fetchFavs()
        
        UDKey.favouritesID.set(favId)
        UDKey.profileID.set(profileID)
        return true
    }
    
    func fetchFavs() async {
        favsFetchBlocked.setTrue()
        guard let profileID = await Favourite.getUserID() else {
            favsFetchBlocked.setFalse()
            return
        }
        guard let favID = await Favourite.getOrCreateID(profileID: profileID) else {
            favsFetchBlocked.setFalse()
            return
        }
        guard let res = await Favourite.fetch(favID) else {
            favsFetchBlocked.setFalse()
            return
        }
        let ids = Favourite.array(res.movieIDtmdb)
        
        do {
            favs = []
            for id in ids {
                let res = try await Network.request(FavouriteTMDBMovie.self, environment: .tmdb, endpoint: TmDB.specificMovie(id))
                favs.append(res)
                print("\n\n\n\n\n\n\n\nres\n\(res)")
                
            }
        } catch {
            print(error.localizedDescription)
        }
        favsFetchBlocked.setFalse()
    }
}
