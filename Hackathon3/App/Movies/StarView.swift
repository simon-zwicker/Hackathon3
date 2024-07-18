//
//  StarView.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation
import SwiftUI

struct StarView: View {
    let rating: Double
    var body: some View {
        ForEach(0..<10) {index in
            if rating > index.double {
                Image(systemName: "star.fill")
            }
        }
    }
}
