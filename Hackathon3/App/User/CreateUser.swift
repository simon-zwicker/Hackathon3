//
//  CreateUser.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct CreateUser: View {
    @State var name: String = ""
    @State var genderSelection: Gender = .diverse
    @State var showNameEmpty: Bool = false
    @State var creationFailed: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
            }
            Section(header: Text("Gender")) {
                Picker("", selection: $genderSelection) {
                    ForEach(Gender.allCases, id: \.rawValue) { gender in
                        Text(gender.displayName).tag(gender)
                    }
                }
                .pickerStyle(PalettePickerStyle())
            }
            Button {
                setup()
            } label: {
                Text("Account erstellen")
            }
        }
        .alert("Bitte trage einen Namen ein", isPresented: $showNameEmpty) {
            Button {
                showNameEmpty.setFalse()
            } label: {
                Text("OK")
            }
        }
        .alert("Profilerstellung fehlgeschlagen", isPresented: $creationFailed) {
            Button {
                setup()
            } label: {
                Text("Erneut versuchen")
            }
            Button {
                creationFailed.setFalse()
            } label: {
                Text("Abbrechen")
            }
        }
    }
    
    func setup() {
        Task {
            if name.isEmpty {
                showNameEmpty.setTrue()
                return
            }
            guard let profileID = await Profile.create(name, gender: genderSelection, location: "49.006889,8.403653") else { return creationFail() }
            guard let favID = await Favourite.create("", profileID: profileID) else { return creationFail() }
            UDKey.favouritesID.set(favID)
            UDKey.profileID.set(profileID)
            creationFailed.setFalse()
            dismiss()
        }
    }
    
    func creationFail() {
        creationFailed.setTrue()
    }
}
