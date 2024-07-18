//
//  MovieCard.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI
import SwiftChameleon

struct MovieCard: View {
    let movie: TMDBMovie
    @State var liked: Bool = false
    @State var failed: Bool = false
    @State var timer: Timer? = nil
    @State var showDetail: Bool = false
    
    var body: some View {
        ZStack {
            Color.navigation.lighter(by: 40)
            VStack(alignment: .leading) {
                if let url = URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)") {
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
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .lineLimit(1)
                        .font(.title3)
                    HStack {
                        Spacer()
                        movie.voteAverage.stars
                            .font(.caption2)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 15)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 27, style: .continuous))
        .onTapGesture(perform: tapped)
        .sheet(isPresented: $showDetail) {
            MovieDetail(movie: movie, liked: $liked)
        }
    }
    
    private func tapped() {
        guard let timer else {
            createTimer()
            return
        }
        if !timer.isValid {
            createTimer()
            return
        }
        timer.invalidate()
        liked.toggle()
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
            showDetail = true
            timer.invalidate()
        }
    }
}

struct LoadFailedView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(.thinMaterial)
            .overlay {
                Image(systemName: "x.circle")
                    .foregroundStyle(.red)
            }
    }
}

