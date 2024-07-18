//
//  MatchStackCard.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI
import Kingfisher

struct MatchStackCard: View {

    let movie: TMDBMovie
    let index: Int

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let index = CGFloat(index)
            let topOffset = (index <= 2 ? index: 2) * 15

            VStack {
                ZStack {
                    if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)") {
                        KFImage.url(url)
                             .loadDiskFileSynchronously()
                             .cacheMemoryOnly()
                             .fade(duration: 0.25)
                             .resizable()
                             .scaledToFill()
                    }

                    VStack {
                        Spacer()

                        HStack {
                            Text(movie.title)
                                .font(.Bold.title)

                            Spacer()

                            Text(movie.popularity.string())
                        }
                        .padding()
                        .background(.white.opacity(0.9))
                        .shadow(radius: 20)
                    }
                    .offset(y: -12)
                }
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 15.0))
                .offset(y: topOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}
