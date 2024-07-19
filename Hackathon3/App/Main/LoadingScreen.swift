//
//  LoadingScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 19.07.24.
//

import SwiftUI

struct LoadingScreen: View {

    @Environment(ProfilesModel.self) private var profilesModel
    @Environment(MoviesModel.self) private var moviesModel
    @Environment(MatchMovieModel.self) private var matchModel
    @Binding var isLoading: Bool

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
                .background(.logobg)

            VStack {
                Image("appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)

                ProgressView("Daten werden geladen ...")
            }
        }
        .task {
            Task {
                await moviesModel.fetch()
                await matchModel.fetch()
                await profilesModel.fetch()
                self.isLoading.setFalse()
            }
        }
    }
}
