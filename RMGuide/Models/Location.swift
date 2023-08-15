//
//  Location.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 15.08.2023.
//

import Foundation

struct RMLocationInfo: Decodable {
    let info: PaginationLocationInfo?
    let results: [RMLocation]?
}

struct PaginationLocationInfo: Decodable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

struct RMLocation: Decodable {
    let id: Int?
    let name: String?
    let type: String?
    let gender: String?
    let dimension: String?
    let residents: [String]?
    let url: String?
    let created: String?
}
