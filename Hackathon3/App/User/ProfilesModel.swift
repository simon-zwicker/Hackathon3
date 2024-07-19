//
//  ProfilesModel.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 19.07.24.
//

import CoreLocation
import SwiftUI

@Observable
class ProfilesModel {
    var profiles: [Profile] = []
    var favs: [FavouriteTMDBMovie] = []
    var favsFetchBlocked = false

    var mapFilterRadius: Bool = true
    var mapRadius: Double = 2

    var mapProfiles: [Profile] {
        guard let user = userProfile else { return [] }
        var filtered: [Profile] = []
        for profile in profiles {
            guard profile.id != user.id else { continue }
            if mapFilterRadius {
                let user2d = getLocation(user)
                let location2d = getLocation(profile)
                let distance = CLLocation(latitude: location2d.latitude, longitude: location2d.longitude)
                    .distance(from: CLLocation(latitude: user2d.latitude, longitude: user2d.longitude))

                if distance <= (mapRadius * 1000) {
                    filtered.append(profile)
                }
            } else {
                filtered.append(profile)
            }
        }
        return filtered
    }

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

    func createUser(_ name: String, _ gender: Gender, _ location: CLLocationCoordinate2D? = nil) async -> Bool {
        guard
        let profileID = await Profile.create(
            name,
            gender: gender,
            location: "\(String(location?.latitude ?? 0.0)),\(String(location?.longitude ?? 0.0))"
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
        Task {
            await fetch()
        }
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

    func getLocation(_ profile: Profile) -> CLLocationCoordinate2D {
        let latLong = profile.location.toArrayComma
        let lat = Double(latLong[0]) ?? 0.0
        let long = Double(latLong[1]) ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
