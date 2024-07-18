//
//  Double.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

import SwiftUI

extension Double {

    var stars: Text {
        let rating = self.roundedTo(2) / 2
        var text = Text("\(rating.string(2)) ")
        for i in 1...5 {
            if rating > i.double {
                text = text + Text(Image(systemName: "star.fill"))
            } else if (i.double - 0.7 ... i.double - 0.3).contains(rating) {
                text = text + Text(Image(systemName: "star.leadinghalf.filled"))
            } else if i.double - 0.3 < rating {
                text = text + Text(Image(systemName: "star.fill"))
            } else {
                text = text + Text(Image(systemName: "star"))
            }
        }
        return text
    }
}
