//
//  Hackathon3App.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import SwiftUI

@main
struct Hackathon3App: App {

    @State private var locationManager: LocationManager = .init()

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(locationManager)
        }
    }
}
