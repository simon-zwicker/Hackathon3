//
//  PocketBase.swift
//  Hackathon3
//
//  Created by Mia Koring on 18.07.24.
//

import Foundation

struct PocketBase<T: Codable>: Codable {
    let page: Int
    let perPage: Int
    let totalPages: Int
    let totalItems: Int
    let items: [T]
}
