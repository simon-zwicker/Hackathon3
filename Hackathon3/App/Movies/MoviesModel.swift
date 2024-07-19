//
//  MoviesModel.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 19.07.24.
//

import Foundation

@Observable
class MoviesModel {

    var movies: [TMDBMovie] = []

    func fetch() async {
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
