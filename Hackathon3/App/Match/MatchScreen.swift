//
//  MatchScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MatchScreen: View {

    @Environment(MatchMovieModel.self) var matchModel: MatchMovieModel

    var body: some View {
        VStack {

            Text("Match the Movie")
                .font(.Bold.large)
                .rotationEffect(.degrees(-8))
                .foregroundStyle(.match.gradient)

            GenrePicker()

            ZStack {
                if matchModel.isLoading {
                    ProgressView("Filme werden geladen")
                } else if matchModel.displayingMovies.isEmpty && !matchModel.isLoading {
                    VStack {
                        Text("Mehr Matches suchen?")
                        Text("Gib mir mehr!")
                            .button {
                                matchModel.fetch()
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
                    .button {
                        withAnimation {
                            matchModel.doSwipe()
                        }
                    }

                Image(systemName: "heart.fill")
                    .font(.Bold.title4)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(15.0)
                    .background(.match.lighter(by: 10.0).gradient)
                    .clipShape(.circle)
                    .frame(maxWidth: .infinity)
                    .button {
                        withAnimation {
                            matchModel.doSwipe(right: true)
                        }
                    }
            }
        }
        .padding()
        .onAppear {
            matchModel.fetch()
        }
    }
}

#Preview {
    MatchScreen()
}
