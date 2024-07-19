//
//  Gender.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

enum Gender: Int, CaseIterable {
    case male, female, diverse
}

extension Gender {
    var dbName: String {
        switch self {
        case .male:
            "male"
        case .female:
            "female"
        case .diverse:
            "diverse"
        }
    }
    
    var displayName: String {
        switch self {
        case .male:
            "männlich"
        case .female:
            "weiblich"
        case .diverse:
            "divers"
        }
    }
}
