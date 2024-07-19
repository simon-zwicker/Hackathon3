//
//  FavouritesRow.swift
//  Hackathon3
//
//  Created by Mia Koring on 19.07.24.
//

import Foundation
import SwiftUI
import Kingfisher

struct FavouritesRow: View {
    let movie: FavouriteTMDBMovie
    @State var showDetail: Bool = false
    
    var body: some View {
        HStack {
            if let url = URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath)") {
                KFImage(url)
                    .placeholder { _ in
                        ProgressView().progressViewStyle(.circular)
                    }
                    .cacheOriginalImage(true)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .frame(width: 50)
            } else {
                LoadFailedView(error: "URL invalid")
            }
            VStack(alignment: .leading) {
                Text(movie.title)
                    .lineLimit(1)
                movie.voteAverage.stars
                    .foregroundStyle(.orange)
            }
            .padding(.leading, 10)
        }
        .onTapGesture {
            showDetail.setTrue()
        }
        .sheet(isPresented: $showDetail) {
            MovieDetail(favMovie: movie)
        }
    }
}
