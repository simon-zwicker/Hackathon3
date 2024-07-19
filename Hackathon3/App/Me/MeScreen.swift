//
//  MeScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MeScreen: View {

    @Environment(ProfilesModel.self) private var profilesModel

    var body: some View {
        VStack(spacing: 40.0) {
            if let profile = profilesModel.userProfile {
                MeImage(name: profile.name)

                VStack(alignment: .leading) {
                    HStack {
                        Text("Meine Favoriten")
                            .font(.Bold.heading1)
                            .padding()
                        Image(systemName: "arrow.counterclockwise")
                            .button {
                                Task {
                                    await profilesModel.fetchFavs()
                                }
                            }
                            .disabled(profilesModel.favsFetchBlocked)
                    }
                    List {
                        ForEach(profilesModel.favs, id: \.id) { movie in
                            FavouritesRow(movie: movie)
                                .swipeActions() {
                                    Button(role: .destructive) {
                                        Task {
                                            await Favourite.changeOne(movieID: movie.id, favourised: false)
                                            UDKey.favourised(movie.id).set(false)
                                            profilesModel.favs.removeAll(where: {$0.id == movie.id}) //to fix bug where for a short time the deleted movie reappears
                                            await profilesModel.fetchFavs()
                                        }
                                    } label: {
                                        Image(systemName: "heart.slash")
                                    }
                                }
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "Profil nicht geladen",
                    systemImage: "xmark",
                    description: Text("Fehler beim Laden des Profils.")
                )
            }
        }
        .padding(.vertical)
        .onAppear {
            Task {
                await profilesModel.fetchFavs()
            }
        }
    }
}
