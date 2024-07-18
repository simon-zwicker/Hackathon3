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
        VStack {
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    } else if phase.error != nil {
                        LoadFailedView()
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
                        .button {
                            liked.toggle()
                        }
                        .padding(10)
                }
            } else {
                LoadFailedView()
            }
            if let omdb {
                Text(omdb.title ?? "Failed")
                Text(omdb.plot ?? "Failed")
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

