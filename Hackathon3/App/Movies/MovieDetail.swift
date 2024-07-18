//
//  MovieDetail.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct MovieDetail: View {
    let movie: TMDBMovie
    @Binding var liked: Bool
    @State var omdb: OMDBMovie? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                .ignoresSafeArea(edges: .top)
                            Spacer()
                        } else if let error = phase.error {
                            LoadFailedView(error: error.localizedDescription)
                        } else {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(.thinMaterial)
                                .overlay {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "heart\(liked ? ".fill" : "")")
                            .foregroundStyle(.ultraThickMaterial)
                            .padding(20)
                            .font(.title)
                            .button {
                                liked.toggle()
                            }
                        
                    }
                } else {
                    LoadFailedView(error: "URL invalid")
                }
                VStack {
                    if let omdb {
                        if let plot = omdb.plot, let actors = omdb.actors, let awards = omdb.awards {
                            VStack {
                                Text("OMDB")
                                    .font(.footnote)
                                    .padding(3)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke()
                                    }
                                MovieInformation(title: movie.title, plot: plot, actors: actors, awards: awards)
                            }
                        }
                        else {
                            VStack {
                                Text("TMDB")
                                    .font(.footnote)
                                    .padding(2)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke()
                                    }
                                MovieInformation(title: movie.title, plot: movie.overview, actors: "", awards: "")
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .task {
            do {
                let res = try await Network.request(OMDBMovie.self, environment: .ombd, endpoint: OMDB.byTitle(movie.originalTitle))
                omdb = res
            } catch {
                print("\n\n\n\n\n\n\(error.localizedDescription)\n\n\n\n\n\n\n")
            }
        }
    }
}

