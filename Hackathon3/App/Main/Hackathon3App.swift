//
//  Hackathon3App.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import SwiftUI

@main
struct Hackathon3App: App {

    @State private var profilesModel: ProfilesModel = .init()
    @State private var moviesModel: MoviesModel = .init()
    @State private var matchModel: MatchMovieModel = .init()
    @State private var locationManager: LocationManager = .init()
    @State var isLoading: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingScreen(isLoading: $isLoading)
                } else {
                    MainScreen()
                }
            }
            .environment(locationManager)
            .environment(matchModel)
            .environment(moviesModel)
            .environment(profilesModel)
        }
    }
}
