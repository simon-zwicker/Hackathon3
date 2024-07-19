//
//  TabItem.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case movies = "Movies"
    case map = "Map"
    case match = "Match"
    case favs = "Favourites"
    case me = "Me"
}

extension TabItem {
    var icon: String {
        switch self {
        case .movies: "movieclapper.fill"
        case .map: "map.fill"
        case .match: "heart.fill"
        case .me: "person.fill"
        case .favs: "star"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .movies: MoviesScreen().padding(.horizontal, 10)
        case .map: MapScreen()
        case .match: MatchScreen()
        case .me: MeScreen()
        case .favs: FavList()
        }
    }
}
