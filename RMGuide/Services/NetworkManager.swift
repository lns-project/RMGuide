//
//  NetworkManager.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 16.08.2023.
//

import Foundation

enum Link {
    case charactersURL
    case locationURL
    case episodeURL
    
    var url: URL {
        switch self {
        case .charactersURL:
            return URL(string: "https://rickandmortyapi.com/api/character")!
        case .locationURL:
            return URL(string: "https://rickandmortyapi.com/api/location")!
        case .episodeURL:
            return URL(string: "https://rickandmortyapi.com/api/episode")!
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    
    var currentPage = 1
    var itemsCount = 20

    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: String, completion: @escaping(Result<Data,NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {
        
//        guard let url = getUrl() else {
//            completion(.failure(.invalidURL))
//            return
//        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let dataModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    private func getUrl() -> URL? {
        let dictionary: [AnyHashable: Any] = [
        "page": currentPage
        ]
        
        let url = Link.charactersURL.url
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = dictionary.map{ return URLQueryItem(name: "\($0)", value: "\($1)")}
        return urlComponents?.url
    }
    
}
