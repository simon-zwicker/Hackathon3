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
    var genre: Int = UserDefaults().integer(forKey: "selectedGenre")

    init() {
        self.currentMovies = nil
        self.fetchedMovies = []
        self.displayingMovies = []
    }

    func fetch(userInitiated: Bool = false) {
        if genre == 0 {
            genre = Genre.action.rawValue
        }
        let next: Bool = !currentMovies.isNil
        let page = {
            let defaultsValue = UserDefaults().integer(forKey: "page\(genre)")
            if userInitiated {
                return defaultsValue + 1
            }
            return defaultsValue > 0 ? defaultsValue : 1
        }()
        if next {
            guard let totalPages = currentMovies?.totalPages, page < totalPages else { return }
        }
    
        Task {
            do {
                print(page, genre)
                let data = try await Network.request(
                    TMDBMovies.self,
                    environment: .tmdb,
                    endpoint: TmDB.movie("\(self.genre)", page)
                )
                UserDefaults().set(page, forKey: "page\(self.genre)")
                
                self.currentMovies = data
                self.fetchedMovies.append(contentsOf: data.results)
                self.displayingMovies = data.results
                self.hasNextPage = data.page < data.totalPages
            } catch {
                print("Error on getting Movies: \(error.localizedDescription)")
            }
        }
    }

    func getIndex(_ movie: TMDBMovie) -> Int {
        displayingMovies.firstIndex(where: { $0.id == movie.id }) ?? 0
    }
}
