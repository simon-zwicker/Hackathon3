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
    var size: CGFloat = 80.0
    var mapAnnotation: Bool = false
    var color: Color = .profile

    var body: some View {
        VStack {
            if !mapAnnotation {
                Text(name)
                    .font(.Regular.title2)
            }

            Circle()
                .fill(color.gradient)
                .frame(width: size, height: size)
                .overlay {
                    Text("\(name.first?.description ?? "")")
                        .font(mapAnnotation ? .Bold.regular: .Bold.extraLarge)
                        .foregroundStyle(.white.opacity(0.6))
                }
        }
    }
}

#Preview {
    MeImage(name: "Simon")
}
