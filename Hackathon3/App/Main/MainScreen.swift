//
//  ContentView.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import SwiftUI
import SwiftChameleon

struct MainScreen: View {

    @State private var selected: TabItem = .movies

    var body: some View {
        TabView(selection: $selected) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tab.view
                    .tabItem { Label(tab.rawValue, systemImage: tab.icon) }
            }
        }
    }
}
