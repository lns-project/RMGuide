//
//  Character.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 15.08.2023.
//

import Foundation

struct RMCharacterInfo: Decodable {
    let info: [PaginationCharacterInfo]?
    let results: [RMCharacter]?
}

struct PaginationCharacterInfo: Decodable {
    let count: Int?
    let pages: Int?
    let next: URL?
    let prev: URL?
}

struct RMCharacter: Decodable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: [Origin]?
    let location: [Location]?
    let image: URL?
    let episode: [URL]?
    let url: URL?
    let created: String?
}

struct Origin: Decodable {
    let name: String?
    let url: URL?
}

struct Location: Decodable {
    let name: String?
    let url: URL?
}
