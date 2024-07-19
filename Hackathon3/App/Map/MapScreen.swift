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
    @State var choosedProfile: Profile?
    @State var radius: Double = 5_000
    var position: MapCameraPosition {
        showLocation()
    }

    var body: some View {
        ZStack {
            Map(initialPosition: position) {
                ForEach(profilesModel.profiles.filter({ $0.id != profilesModel.userProfile?.id }), id: \.id) { profile in

                    Annotation(profile.name, coordinate: getLocation(profile)) {
                        MeImage(name: profile.name, size: 30.0, mapAnnotation: true, color: .blue)
                            .onTapGesture(perform: { choosedProfile = profile })
                    }
                }

                if let user = profilesModel.userProfile {
                    Annotation(user.name, coordinate: getLocation(user)) {
                        MeImage(name: user.name, size: 30.0, mapAnnotation: true)
                    }

                    MapCircle(center: getLocation(user), radius: CLLocationDistance(radius))
                            .foregroundStyle(.blue.opacity(0.4))
                            .stroke(.blue, lineWidth: 1.0)
                            .mapOverlayLevel(level: .aboveLabels)
                }
            }
            .mapControls {
                MapCompass()
            }
        }
        .onAppear {
            locationManager.requestAuth()
        }
        .sheet(item: $choosedProfile) {
            self.choosedProfile = nil
        } content: { profile in
            VStack {
                MeImage(name: profile.name, color: .blue)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }

    private func getLocation(_ profile: Profile) -> CLLocationCoordinate2D {
        let latLong = profile.location.toArrayComma
        let lat = Double(latLong[0]) ?? 0.0
        let long = Double(latLong[1]) ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    private func showLocation() -> MapCameraPosition {
        guard let profile = profilesModel.userProfile else { return MapCameraPosition.automatic }
        let coord = getLocation(profile)
        return MapCameraPosition.camera(.init(centerCoordinate: coord, distance: (radius * 10)))
    }
}
