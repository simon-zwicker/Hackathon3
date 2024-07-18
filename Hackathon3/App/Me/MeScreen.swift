//
//  MeScreen.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

struct MeScreen: View {

    @State var favs: [String] = []

    var body: some View {
        VStack(spacing: 40.0) {
            MeImage(name: "Simon")

            VStack(alignment: .leading) {
                Text("Meine Favoriten")
                    .font(.Bold.heading1)
                    .padding()

                List {
                    ForEach(favs, id: \.self) { fav in
                        Text(fav)
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    MeScreen(favs: ["Hulk", "Ironman"])
}
