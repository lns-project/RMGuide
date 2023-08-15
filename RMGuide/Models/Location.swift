//
//  Location.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 15.08.2023.
//

import Foundation

struct RMLocationInfo: Decodable {
    let info: [PaginationLocationInfo]?
    let results: [RMLocation]?
}

struct PaginationLocationInfo: Decodable {
    let count: Int?
    let pages: Int?
    let next: URL?
    let prev: URL?
}

struct RMLocation: Decodable {
    let id: Int?
    let name: String?
    let type: String?
    let gender: String?
    let dimension: String?
    let residents: [URL]?
    let url: URL?
    let created: String?
}
