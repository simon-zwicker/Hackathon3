//
//  CreateUser.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct CreateUser: View {
    @Environment(ProfilesModel.self) private var profilesModel
    @Environment(LocationManager.self) private var locationManager
    @State var name: String = ""
    @State var genderSelection: Gender = .diverse
    @Environment(\.dismiss) var dismiss
    @State var isLoading: Bool = false

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

            ZStack {
                if isLoading {
                    ProgressView("Account erstellen ...")
                } else {
                    Text("Account erstellen")
                        .foregroundStyle(name.isEmpty ? .gray: .blue)
                        .disabled(name.isEmpty)
                        .button {
                            isLoading.setTrue()
                            createAccount()
                        }
                }
            }
        }
        .onAppear {
            locationManager.requestAuth()
        }
    }

    private func createAccount() {
        Task {
            let success = await profilesModel.createUser(name, genderSelection, locationManager.location)
            isLoading.setFalse()
            if success {
                dismiss()
            }
        }
    }
}
