//
//  GenrePicker.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct GenrePicker: View {
    @Environment(MatchMovieModel.self) var matchModel
    @State var selected: Genre = .action

    var body: some View {
        VStack {
            Picker("Genre wählen", selection: $selected) {
                ForEach(Genre.allCases, id: \.rawValue) { genre in
                    Text(genre.name)
                        .tag(genre)
                }
            }
        }
        .onAppear {
            selected = Genre(rawValue: matchModel.genre) ?? .action
        }
        .onChange(of: selected) {
            matchModel.changeGenre(selected.rawValue)
        }
    }
}
