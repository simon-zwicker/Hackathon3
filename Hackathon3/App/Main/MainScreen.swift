//
//  ContentView.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 17.07.24.
//

import SwiftUI
import SwiftChameleon

struct MainScreen: View {

    @Environment(ProfilesModel.self) private var profilesModel
    @State private var selected: TabItem = .match
    @State private var showUserCreation: Bool = false

    var body: some View {
        TabView(selection: $selected) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tab.view
                    .tabItem { Label(tab.rawValue, systemImage: tab.icon) }
            }
        }
        .onAppear {
            showUserCreation = profilesModel.userProfile.isNil
        }
        .sheet(isPresented: $showUserCreation) {
            CreateUser()
                .interactiveDismissDisabled()
                .presentationDetents([.height(450.0)])
        }
    }
}
