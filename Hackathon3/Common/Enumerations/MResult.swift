//
//  Result.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

enum MResult<T: Any, E: Error> {
    case ok(T)
    case error(E)
}
