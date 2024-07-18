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
        GeometryReader { reader in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(/*.fixed(reader.size.width / 2 - 16)*/.flexible(), spacing: 10
                                                            ), count: 2)) {
                    ForEach(movies.sorted(by: {$0.voteAverage > $1.voteAverage}), id: \.self) { movie in
                        MovieCard(movie: movie)
                    }
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
