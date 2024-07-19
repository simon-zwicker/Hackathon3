//
//  ProfilesModel.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 19.07.24.
//

import Foundation

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
        
        UDKey.favouritesID.set(favId)
        UDKey.profileID.set(profileID)
        return true
    }
}
