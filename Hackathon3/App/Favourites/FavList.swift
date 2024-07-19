//
//  FavList.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct FavList: View {
    @State var favs: [TMDBMovie] = []
    @State var showUserCreation: Bool = false
    @State var showLoadingError: Bool = false
    
    var body: some View {
        VStack {
            ForEach(favs, id: \.self) { movie in
                Text(movie.title)
            }
        }
        .task {
            loadFavMovies()
        }
        .sheet(isPresented: $showUserCreation) {
            CreateUser()
                .interactiveDismissDisabled()
        }
        .alert("Beim Laden ist ein fehler aufgetreten", isPresented: $showLoadingError) {
            Button {
                loadFavMovies()
            } label: {
                Text("Erneut versuchen")
            }
            Button {
                showLoadingError.setFalse()
            } label: {
                Text("Abbrechen")
            }
        }
    }
    
    private func loadFavMovies() {
        Task {
            guard let profileID = await Favourite.getUserID() else {
                showUserCreation.setTrue()
                return
            }
            guard let favID = await Favourite.getOrCreateID(profileID: profileID) else {
                showLoadingError.setTrue()
                return
            }
            guard let res = await Favourite.fetch(favID) else {
                showLoadingError.setTrue()
                return
            }
            let ids = Favourite.array(res.movieIDtmdb)
            
            do {
                for id in ids {
                    let res = try await Network.request(FavouriteTMDBMovie.self, environment: .tmdb, endpoint: TmDB.specificMovie(id))
                    print("\n\n\n\n\n\n\n\nres\n\(res)")
                    
                }
                print("\n\n\n\n\n\n\n\n\(favs)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
