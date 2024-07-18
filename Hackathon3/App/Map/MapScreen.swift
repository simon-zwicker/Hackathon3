//
//  MapScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI
import MapKit

struct MapScreen: View {

    @Environment(LocationManager.self) private var locationManager
    private var locationUpdated: Bool = false

    var body: some View {
        ZStack {
            Map()
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }

        }
        .onAppear {
            locationManager.requestAuth()
        }
    }
}
