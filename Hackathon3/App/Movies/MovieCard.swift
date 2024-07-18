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
                        stars(rating: movie.voteAverage)
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
    
    private func stars(rating: Double) -> Text {
        let rating = rating.roundedTo(2) / 2
        var text = Text("\(rating.string(2)) ")
        for i in 1...5 {
            if rating > i.double {
                text = text + Text(Image(systemName: "star.fill"))
            } else if (i.double - 0.7 ... i.double - 0.3).contains(rating) {
                text = text + Text(Image(systemName: "star.leadinghalf.filled"))
            } else if i.double - 0.3 < rating {
                text = text + Text(Image(systemName: "star.fill"))
            } else {
                text = text + Text(Image(systemName: "star"))
            }
        }
        return text
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

