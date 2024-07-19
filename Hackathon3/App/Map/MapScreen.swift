//
//  MapScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI
import MapKit

struct MapScreen: View {

    @Environment(ProfilesModel.self) private var profilesModel
    @Environment(LocationManager.self) private var locationManager
    private var locationUpdated: Bool = false

    var body: some View {
        ZStack {
            Map {
                ForEach(profilesModel.profiles.filter({ $0.id != profilesModel.userProfile?.id }), id: \.id) { profile in
                    Marker(profile.name, coordinate: getLocation(profile))
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }

        }
        .onAppear {
            locationManager.requestAuth()
        }
    }

    private func getLocation(_ profile: Profile) -> CLLocationCoordinate2D {
        let latLong = profile.location.toArrayComma
        let lat = Double(latLong[0]) ?? 0.0
        let long = Double(latLong[1]) ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
