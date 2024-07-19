//
//  String.swift
//  Hackathon3
//
//  Created by Simon Zwicker on 18.07.24.
//

extension String {

    var toArrayComma: [String] {
        self.components(separatedBy: ",").compactMap({ $0.trimmingCharacters(in: .whitespaces) })
    }
}
