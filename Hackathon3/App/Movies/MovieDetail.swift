//
//  MovieDetail.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI
import Kingfisher

struct MovieDetail: View {
    var movie: TMDBMovie? = nil
    var favMovie: FavouriteTMDBMovie? = nil
    var liked: Binding<Bool>?
    @State var omdb: OMDBMovie? = nil
    var likeDisabled: Binding<Bool>?
    var toggleLike: (() -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.isNil ? (favMovie.isNil ? "" : favMovie?.posterPath ?? "") : movie?.posterPath ?? "")") {
                    KFImage(url)
                        .placeholder { _ in
                            ProgressView().progressViewStyle(.circular)
                        }
                        .cacheOriginalImage(true)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .overlay(alignment: .bottomTrailing) {
                        if let liked, let likeDisabled, let toggleLike {
                            Image(systemName: "heart\(liked.wrappedValue ? ".fill" : "")")
                                .foregroundStyle(.ultraThickMaterial)
                                .padding(20)
                                .font(.title)
                                .button {
                                    toggleLike()
                                }
                                .disabled(likeDisabled.wrappedValue)
                        }
                    }
                } else {
                    LoadFailedView(error: "URL invalid")
                }
                VStack {
                    if let omdb, let plot = omdb.plot, let actors = omdb.actors, let awards = omdb.awards {
                            VStack {
                                Text("OMDB")
                                    .font(.footnote)
                                    .padding(3)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke()
                                    }
                                MovieInformation(title: movie.isNil ? (favMovie.isNil ? "Failed" : favMovie?.title ?? "Failed") : movie?.title ?? "Failed", plot: plot, actors: actors, awards: awards)
                            }
                    } else {
                        VStack {
                            Text("TMDB")
                                .font(.footnote)
                                .padding(2)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke()
                                }
                            if let movie {
                                MovieInformation(title: movie.title, plot: movie.overview, actors: "", awards: "")
                            } else if let favMovie {
                                MovieInformation(title: favMovie.title, plot: "Unavailable", actors: "", awards: "")
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .task {
            var title = ""
            if let movie { title = movie.originalTitle }
            else if let favMovie { title = favMovie.title }
            else { return }
            let res = try? await Network.request(OMDBMovie.self, environment: .ombd, endpoint: OMDB.byTitle(title))
            omdb = res
        }
    }
}

