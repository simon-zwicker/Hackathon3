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
    @State var radius: Double = 2
    @State var position: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            Map(position: $position) {
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

                    MapCircle(center: getLocation(user), radius: CLLocationDistance(radius * 1000))
                            .foregroundStyle(.blue.opacity(0.4))
                            .stroke(.blue, lineWidth: 1.0)
                            .mapOverlayLevel(level: .aboveLabels)
                }
            }
            .mapControls {
                MapCompass()
            }

            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Radius einstellen: \(radius.string(0)) km")
                        .font(.Bold.regular)
                    Slider(value: $radius, in: 2...200, step: 2.0)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
                .background(.white.opacity(0.95))
                .clipShape(.rect(cornerRadius: 20.0))
                .padding()
            }
        }
        .onAppear {
            locationManager.requestAuth()
            showLocation()
        }
        .sheet(item: $choosedProfile) {
            self.choosedProfile = nil
        } content: { profile in
            MapProfile(profile: profile)
                .presentationDetents([.medium])
        }
        .onChange(of: radius) {
            showLocation()
        }
    }

    private func getLocation(_ profile: Profile) -> CLLocationCoordinate2D {
        let latLong = profile.location.toArrayComma
        let lat = Double(latLong[0]) ?? 0.0
        let long = Double(latLong[1]) ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    private func showLocation() {
        guard let profile = profilesModel.userProfile else { return }
        let coord = getLocation(profile)
        position = MapCameraPosition.camera(.init(centerCoordinate: coord, distance: (radius * 10000)))
    }
}
