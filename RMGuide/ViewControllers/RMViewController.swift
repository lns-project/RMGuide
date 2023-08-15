//
//  RMViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 15.08.2023.
//

import UIKit

enum Link: String {
    case charactersURL = "https://rickandmortyapi.com/api/character"
    case locationURL = "https://rickandmortyapi.com/api/location"
    case episodeURL = "https://rickandmortyapi.com/api/episode"
}

enum UserAction: String, CaseIterable {
    case fetchCharacters = "Fetch Characters"
    case fetchLocation = "Fetch Location"
    case fetchEpisode = "Fetch Episode"
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

final class RMViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath)
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .fetchCharacters: fetchCharacters()
        case .fetchLocation: fetchLocation()
        case .fetchEpisode: fetchEpisode()
        }
    }
    
    private func showAlert(withStatus status: Alert) {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
    }

}

extension RMViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

extension RMViewController {
    private func fetchCharacters() {
        guard let url = URL(string: Link.charactersURL.rawValue) else { return }
                
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let charInfo = try decoder.decode(RMCharacterInfo.self, from: data)
                print(charInfo)
                self?.showAlert(withStatus: .success)
            } catch let error {
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
    
    private func fetchLocation() {
        guard let url = URL(string: Link.locationURL.rawValue) else { return }
                
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let charInfo = try decoder.decode(RMLocationInfo.self, from: data)
                print(charInfo)
                self?.showAlert(withStatus: .success)
            } catch let error {
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }

    
    private func fetchEpisode() {
        guard let url = URL(string: Link.episodeURL.rawValue) else { return }
                
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let charInfo = try decoder.decode(RMEpisodeInfo.self, from: data)
                print(charInfo)
                self?.showAlert(withStatus: .success)
            } catch let error {
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
}
