//
//  ProfilesModel.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 19.07.24.
//

import Foundation
import CoreLocation

@Observable
class ProfilesModel {

    var profiles: [Profile] = []
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
        
        UDKey.favouritesID.set(favId)
        UDKey.profileID.set(profileID)
        Task {
            await fetch()
        }
        return true
    }
}
