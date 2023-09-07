//
//  Person.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 07.09.2023.
//

import Foundation

struct Person: Codable {
    let name: String
    let surname: String
    
    var fullName: String {
        "\(name) \(surname)"
    }
}
