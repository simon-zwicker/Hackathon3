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
    @State var showUserCreation: Bool = false

    var body: some View {
        TabView(selection: $selected) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tab.view
                    .tabItem { Label(tab.rawValue, systemImage: tab.icon) }
            }
        }
        .sheet(isPresented: $showUserCreation) {
            CreateUser()
                .interactiveDismissDisabled()
                .presentationDetents([.medium])
        }
        .task {
            let profileID = UDKey.profileID.value as? String
            let favouritesID = UDKey.favouritesID.value as? String
            
            if let profileID, favouritesID.isNil {
                guard let res = try? await Network.request(Favourite.self, environment: .pock, endpoint: Pockethost.createFavourite("", profileID)) else { return }
                UDKey.favouritesID.set(res.id)
            }
            if profileID.isNil { showUserCreation.setTrue() }
        }
    }
}
