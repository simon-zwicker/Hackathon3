//
//  MatchScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MatchScreen: View {

    @AppStorage("localFavMovies") var localFavs: String = ""
    @State var current: TMDBMovies?
    @State var movies: [TMDBMovie] = []
    @State var choosenGenre: Int = 28
    @State var isLoading: Bool = false

    var body: some View {
        VStack {

            Text("Match the Movie")
                .font(.Bold.large)
                .rotationEffect(.degrees(-8))
                .foregroundStyle(.match.gradient)

            ZStack {
                if isLoading {
                    ProgressView("Filme werden geladen")
                } else if movies.isEmpty {
                    VStack {
                        Text("Mehr Matches suchen?")
                        Text("Gib mir mehr!")
                            .button {
                                fetchMoviesGenres(true)
                            }
                    }
                } else {
                    ForEach(movies, id: \.id) { movie in
                        MatchStackCard(movie: movie, index: getIndex(movie))
                    }
                }
            }
            .padding()
            .padding(.vertical)
            .padding(.bottom, 30.0)

            HStack {
                Image(systemName: "xmark")
                    .font(.Bold.title4)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(15.0)
                    .background(.appSec.lighter(by: 10.0).gradient)
                    .clipShape(.circle)
                    .frame(maxWidth: .infinity)

                Image(systemName: "heart.fill")
                    .font(.Bold.title4)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(15.0)
                    .background(.match.lighter(by: 10.0).gradient)
                    .clipShape(.circle)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .onAppear {
            fetchMoviesGenres()
        }
    }

    private func getIndex(_ movie: TMDBMovie) -> Int {
        movies.firstIndex(of: movie) ?? 0
    }

    private func saveFav(_ value: String) {
        localFavs += "\(value),"
    }

    private func fetchMoviesGenres(_ loadNext: Bool = false) {
        self.movies = []
        Task {
            do {
                let data = try await Network.request(
                    TMDBMovies.self,
                    environment: .tmdb,
                    endpoint: TmDB.movie("\(choosenGenre)")
                )

                self.current = data
                self.movies = data.results.filter({ !localFavs.toArrayComma.contains(String($0.id)) })
            } catch {
                print("Error Getting Movies")
            }
        }
    }
}

#Preview {
    MatchScreen()
}
