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
    @State var position: MapCameraPosition = .automatic

    var body: some View {
        @Bindable var profilesModel = profilesModel
        ZStack {
            Map(position: $position) {
                ForEach(profilesModel.mapProfiles, id: \.id) { profile in

                    Annotation(profile.name, coordinate: profilesModel.getLocation(profile)) {
                        MeImage(name: profile.name, size: 30.0, mapAnnotation: true, color: .blue)
                            .onTapGesture(perform: { choosedProfile = profile })
                    }
                }

                if let user = profilesModel.userProfile {
                    Annotation(user.name, coordinate: user.name == "Kevin" ? profilesModel.getLocation(user): locationManager.location ?? .init(latitude: 0.0, longitude: 0.0)) {
                        MeImage(name: user.name, size: 30.0, mapAnnotation: true)
                    }

                    if profilesModel.mapFilterRadius {
                        MapCircle(center: profilesModel.getLocation(user), radius: CLLocationDistance(profilesModel.mapRadius * 1000))
                            .foregroundStyle(.blue.opacity(0.4))
                            .stroke(.blue, lineWidth: 1.0)
                            .mapOverlayLevel(level: .aboveLabels)
                    }
                }
            }
            .mapControls {
                MapCompass()
            }


            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "circle")
                        .font(.Regular.title)
                        .padding(10.0)
                        .foregroundStyle(profilesModel.mapFilterRadius ? Color.white: Color.blue)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(profilesModel.mapFilterRadius ? Color.blue: Color.white)
                        )
                        .button {
                            profilesModel.mapFilterRadius.toggle()
                        }
                }
                .padding()

                Spacer()

                if profilesModel.mapFilterRadius {
                    VStack(alignment: .leading) {
                        Text("Radius einstellen: \(profilesModel.mapRadius.string(0)) km")
                            .font(.Bold.regular)
                        Slider(value: $profilesModel.mapRadius, in: 2...200, step: 2.0)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
                    .background(.white.opacity(0.95))
                    .clipShape(.rect(cornerRadius: 20.0))
                    .padding()
                    .opacity(profilesModel.mapFilterRadius ? 1.0: 0.0)
                    .animation(.easeInOut, value: profilesModel.mapFilterRadius)
                }
            }
        }
        .onAppear {
            locationManager.requestAuth()
            showLocation()
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
        .onChange(of: profilesModel.mapRadius) {
            showLocation()
        }
    }

    private func showLocation() {
        guard let profile = profilesModel.userProfile else { return }
        let coord = profilesModel.getLocation(profile)
        position = MapCameraPosition.camera(.init(centerCoordinate: coord, distance: (profilesModel.mapRadius * 10000)))
    }
}
