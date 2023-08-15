//
//  Episode.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 15.08.2023.
//

import Foundation

struct RMEpisodeInfo: Decodable {
    let info: [PaginationEpisodeInfo]?
    let results: [RMEpisode]?
}

struct PaginationEpisodeInfo: Decodable {
    let count: Int?
    let pages: Int?
    let next: URL?
    let prev: URL?
}

struct RMEpisode: Decodable {
    let id: Int?
    let name: String?
    let air_date: String?
    let episode: String?
    let characters: [URL]?
    let url: URL?
    let created: String?
}
