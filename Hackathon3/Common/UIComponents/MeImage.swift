//
//  MeImage.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI
import SwiftChameleon

struct MeImage: View {

    @State var name: String

    var body: some View {
        VStack {
            Text(name)
                .font(.Regular.title2)

            Circle()
                .fill(.profile.gradient)
                .frame(width: 80, height: 80)
                .overlay {
                    Text("\(name.first?.description ?? "")")
                        .font(.Bold.extraLarge)
                        .foregroundStyle(.white.opacity(0.6))
                }
        }
    }
}

#Preview {
    MeImage(name: "Simon")
}
