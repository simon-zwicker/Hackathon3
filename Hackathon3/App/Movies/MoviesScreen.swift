//
//  MoviesScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MoviesScreen: View {

    @Environment(MoviesModel.self) private var moviesModel
    @State var likeDisabled: Bool = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10
                                                        ), count: 2)) {
                ForEach(moviesModel.movies.sorted(by: {$0.voteAverage > $1.voteAverage}), id: \.self) { movie in
                    MovieCard(movie: movie, likeDisabled: $likeDisabled)
                }
            }
        }
        .task {
            await moviesModel.fetch()
        }
        //http://img.omdbapi.com/?apikey=7699b46&
    }
}


#Preview {
    MoviesScreen()
        .padding(.horizontal, 10)
}
