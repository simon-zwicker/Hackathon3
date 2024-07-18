//
//  MatchMovieModel.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import Foundation

@Observable
class MatchMovieModel {
    var currentMovies: TMDBMovies?
    var fetchedMovies: [TMDBMovie]
    var displayingMovies: [TMDBMovie]

    var hasNextPage: Bool = true

    init() {
        self.currentMovies = nil
        self.fetchedMovies = []
        self.displayingMovies = []
    }

    func fetch(_ genre: Int) {
        let next: Bool = !currentMovies.isNil
        guard let page = next ? currentMovies?.page : 0, hasNextPage, let totalPages = currentMovies?.totalPages, page + 1 < totalPages else { return }
        Task {
            do {
                let data = try await Network.request(
                    TMDBMovies.self,
                    environment: .tmdb,
                    endpoint: TmDB.movie("\(genre)", page + 1)
                )

                self.currentMovies = data
                self.fetchedMovies.append(contentsOf: data.results)
                self.displayingMovies = data.results
                self.hasNextPage = data.page < data.totalPages
            } catch {
                print("Error on getting Movies")
            }
        }
    }

    func getIndex(_ movie: TMDBMovie) -> Int {
        displayingMovies.firstIndex(where: { $0.id == movie.id }) ?? 0
    }
}
