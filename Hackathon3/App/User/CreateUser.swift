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

        VStack(spacing: 30.0) {

            Text("MovieMatch")
                .font(.Bold.large)
                .foregroundStyle(.logobg.gradient)

            VStack {
                Text("Sag uns wer du bist")
                    .font(.Bold.title3)

                TextField("Name eingeben", text: $name)
                    .font(.Bold.title)
                    .multilineTextAlignment(.center)
                    .padding(15.0)
                    .foregroundStyle(.blue.gradient)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue.gradient, lineWidth: 2.0)
                    )
                    .tint(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(20.0)
            }

            VStack {
                Text("Geschlecht auswählen")
                    .font(.Bold.title3)

                Picker("", selection: $genderSelection) {
                    ForEach(Gender.allCases, id: \.rawValue) { gender in
                        Text(gender.displayName)
                            .tag(gender)
                    }
                }
                .pickerStyle(.segmented)
            }

            Text("Account erstellen")
                .font(.Bold.regular)
                .padding(.horizontal, 30.0)
                .padding(.vertical, 15.0)
                .foregroundStyle(.white)
                .disabled(name.isEmpty)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(name.isEmpty ? Color.gray: Color.logobg)
                )
                .loadingButton(isLoading: $isLoading, action: {
                    isLoading.setTrue()
                    createAccount()
                })
        }
        .padding()
        .onAppear {
            locationManager.requestAuth()
        }
    }

    private func createAccount() {
        Task {
            var success: Bool = false
            if name == "Kevin" {
                success = await profilesModel.createUser(name, genderSelection, .init(latitude: 48.137371, longitude: 11.575328))
            } else {
                success = await profilesModel.createUser(name, genderSelection, locationManager.location)
            }
            isLoading.setFalse()
            if success {
                dismiss()
            }
        }
    }
}
