//
//  MovieInformation.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct MovieInformation: View {
    let title: String
    let plot: String
    let actors: String
    let awards: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
            if !plot.isEmpty {
                HorizontalDividerTitle(text: "Handlung")
                Text(plot)
            }
            if !actors.isEmpty {
                HorizontalDividerTitle(text: "Schauspieler")
                Text(actors)
            }
            if !awards.isEmpty {
                HorizontalDividerTitle(text: "Auszeichnungen")
                Text(awards)
            }
        }
    }
}

struct HorizontalDividerTitle: View {
    let text: String
    
    var body: some View {
        VStack {
            Divider()
        }
        .overlay {
            Text(text).font(.title3)
                .padding(.horizontal, 5)
                .background(.background)
        }
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
}
