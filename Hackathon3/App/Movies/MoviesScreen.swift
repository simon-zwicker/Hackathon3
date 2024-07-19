//
//  MoviesScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MoviesScreen: View {

    @State var movies: [TMDBMovie] = []
    @State var likeDisabled: Bool = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10
                                                        ), count: 2)) {
                ForEach(movies.sorted(by: {$0.voteAverage > $1.voteAverage}), id: \.self) { movie in
                    MovieCard(movie: movie, likeDisabled: $likeDisabled)
                }
            }
        }
        .task {
            await fetchTopRated()
        }
        //http://img.omdbapi.com/?apikey=7699b46&
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


#Preview {
    MoviesScreen()
        .padding(.horizontal, 10)
}
