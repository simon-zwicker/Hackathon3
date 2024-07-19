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
        get { UDKey.selectedGenre.value as? Int ?? 28 }
        set { UDKey.selectedGenre.set(newValue) }
    }

    var pageUD: Int {
        get { UDKey.page(genre).value as? Int ?? 1 }
        set { UDKey.page(genre).set(newValue) }
    }

    var isLoading: Bool = false

    init() {
        self.currentMovies = nil
        self.fetchedMovies = []
        self.displayingMovies = []
    }

    func changeGenre(_ genre: Int) {
        self.isLoading.setTrue()
        self.currentMovies = nil
        self.fetchedMovies = []
        self.displayingMovies = []
        self.genre = genre
        fetch()
    }

    func fetch() {
        self.isLoading.setTrue()

        if genre == 0 { genre = Genre.action.rawValue }
        if pageUD == 0 { pageUD = 1 }

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
                self.displayingMovies = data.results.filter({ !getLocalFav($0.id) })
                self.hasNextPage = data.page < data.totalPages
                self.pageUD = data.page
            } catch {
                print("Error on getting Movies: \(error.localizedDescription)")
            }
        }
        self.isLoading.setFalse()
    }

    func getIndex(_ movie: TMDBMovie) -> Int {
        displayingMovies.firstIndex(where: { $0.id == movie.id }) ?? 0
    }

    func doSwipe(right: Bool = false) {
        Task {
            if let movie = displayingMovies.first {
                if right {
                    setLocalFavs(movie.id, add: true)
                }
                displayingMovies.removeFirst()
                _ = await Favourite.changeOne(movieID: movie.id, favourised: right)
            }
        }
    }

    func setLocalFavs(_ tmdbID: Int, add: Bool = false) {
        UDKey.favourised(tmdbID).set(add)
    }

    func getLocalFav(_ tmdbID: Int) -> Bool {
        (UDKey.favourised(tmdbID).value as? Bool) ?? false
    }
}
