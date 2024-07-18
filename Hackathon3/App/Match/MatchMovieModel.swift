//
//  MatchMovieModel.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import Foundation
import SwiftChameleon

@Observable
class MatchMovieModel {
    var currentMovies: TMDBMovies?
    var fetchedMovies: [TMDBMovie]
    var displayingMovies: [TMDBMovie]

    var hasNextPage: Bool = true
    var genre: Int {
        get { UserDefaults.standard.integer(forKey: "selectedGenre") }
        set { UserDefaults.standard.set(newValue, forKey: "selectedGenre") }
    }

    var pageUD: Int {
        get { UserDefaults.standard.integer(forKey: "page\(genre)") }
        set { UserDefaults.standard.set(newValue, forKey: "page\(genre)") }
    }

    var isInFetch = false

    init() {
        self.currentMovies = nil
        self.fetchedMovies = []
        self.displayingMovies = []
    }

    func fetch(userInitiated: Bool = false) {
        self.isInFetch = true

        if genre == 0 { genre = Genre.action.rawValue }
        if pageUD == 0 { pageUD = 1 }

        let next: Bool = !currentMovies.isNil
        guard hasNextPage else { return }
        Task {
            do {
                let data = try await Network.request(
                    TMDBMovies.self,
                    environment: .tmdb,
                    endpoint: TmDB.movie("\(genre)", pageUD)
                )

                self.currentMovies = data
                self.fetchedMovies.append(contentsOf: data.results)
                self.displayingMovies = data.results
                self.hasNextPage = data.page < data.totalPages
                self.pageUD = data.page
            } catch {
                print("Error on getting Movies: \(error.localizedDescription)")
            }
        }
        self.isInFetch = false
    }

    func getIndex(_ movie: TMDBMovie) -> Int {
        displayingMovies.firstIndex(where: { $0.id == movie.id }) ?? 0
    }
}
