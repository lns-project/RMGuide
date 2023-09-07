//
//  StorageManager.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 07.09.2023.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "person"
    
    private init() {}
    
    func save(personType: Person) {
        guard let data = try? JSONEncoder().encode(personType) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchPerson() -> Person? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        guard let person = try? JSONDecoder().decode(Person.self, from: data) else { return nil }
        return person
    }

}
