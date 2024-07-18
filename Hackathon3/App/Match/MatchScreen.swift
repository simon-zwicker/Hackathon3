//
//  MatchScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MatchScreen: View {

    @AppStorage("localFavMovies") var localFavs: String = ""
    @Environment(MatchMovieModel.self) var matchModel: MatchMovieModel
    @State var isLoading: Bool = false
    @State var showSelect: Bool = false

    var body: some View {
        VStack {

            Text("Match the Movie")
                .font(.Bold.large)
                .rotationEffect(.degrees(-8))
                .foregroundStyle(.match.gradient)
            ZStack {
                if isLoading {
                    ProgressView("Filme werden geladen")
                } else if matchModel.displayingMovies.isEmpty {
                    VStack {
                        Text("Mehr Matches suchen?")
                        Text("Gib mir mehr!")
                            .button {
                                matchModel.fetch(userInitiated: true)
                            }
                    }
                } else {
                    ForEach(matchModel.displayingMovies.reversed(), id: \.id) { movie in
                        MatchStackCard(movie: movie)
                    }
                }
            }
            .padding(.top, 30.0)
            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                Image(systemName: "xmark")
                    .font(.Bold.title4)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(15.0)
                    .background(.appSec.lighter(by: 10.0).gradient)
                    .clipShape(.circle)
                    .frame(maxWidth: .infinity)
                
                GenrePicker()
                    .environment(matchModel)
                
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
            matchModel.fetch()
        }
    }

    private func saveFav(_ value: String) {
        localFavs += "\(value),"
    }
}

#Preview {
    MatchScreen()
}
