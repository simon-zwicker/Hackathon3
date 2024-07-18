//
//  GenrePicker.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct GenrePicker: View {
    @State var loadingFailed: Bool = false
    @Environment(MatchMovieModel.self) var matchMovieModel
    @Environment(\.dismiss) var dismiss
    @State var selected: Genre = .action
    @State var block: Bool = true
    var body: some View {
        VStack {
            Picker("Genre wählen", selection: $selected) {
                ForEach(Genre.allCases, id: \.rawValue) { genre in
                    Text(genre.name).tag(genre)
                }
            }
        }
        .alert("Laden von Genres fehlgeschlagen", isPresented: $loadingFailed) {
            Button {
                loadingFailed.setFalse()
            } label: {
                Text("OK")
            }
        }
        .task {
            selected = Genre(rawValue: matchMovieModel.genre) ?? .action
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                block = false
            }
        }
        .onChange(of: selected) {
            if !block {
                matchMovieModel.genre = selected.rawValue
                matchMovieModel.fetch()
                UserDefaults().setValue(selected.rawValue, forKey: "selectedGenre")
                dismiss()
            }
        }
    }
}

let brokenGenres = ["Romance"]
