//
//  MoviesScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MoviesScreen: View {

    @State var movies: [TMDBMovie] = []

    var body: some View {
        List(movies, id: \.id) { movie in
            Text(movie.title)
        }
        .task {
            await fetchTopRated()
        }
    }

    private func fetchTopRated() async {
        do {
            let data = try await Network.request(
                TMDBMovies.self,
                environment: .tmdb,
                endpoint: TmDB.topRated
            )
            print(data)
            self.movies = data.results
        } catch {
            print("error on fetch movies")
        }
    }
}
