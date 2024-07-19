//
//  FavouritesRow.swift
//  Hackathon3
//
//  Created by Mia Koring on 19.07.24.
//

import Foundation
import SwiftUI

struct FavouritesRow: View {
    let movie: FavouriteTMDBMovie
    @State var showDetail: Bool = false
    
    var body: some View {
        Text(movie.title)
            .button {
                showDetail.setTrue()
            }
            .sheet(isPresented: $showDetail) {
                MovieDetail(favMovie: movie)
            }
    }
}
