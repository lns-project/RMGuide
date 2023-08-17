//
//  RMViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 15.08.2023.
//

import UIKit

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
    private let networkManager = NetworkManager.shared
    
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
        NetworkManager.shared.fetch(RMCharacterInfo.self, from: Link.charactersURL.url) { [weak self] result in
            switch result {
            case .success(let character):
                print(character)
                self?.showAlert(withStatus: .success)
            case .failure(let error):
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
    
    private func fetchLocation() {
        NetworkManager.shared.fetch(RMLocationInfo.self, from: Link.locationURL.url) { [weak self] result in
            switch result {
            case .success(let location):
                print(location)
                self?.showAlert(withStatus: .success)
            case .failure(let error):
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
    
    private func fetchEpisode() {
        NetworkManager.shared.fetch(RMEpisodeInfo.self, from: Link.episodeURL.url) { [weak self] result in
            switch result {
            case .success(let episode):
                print(episode)
                self?.showAlert(withStatus: .success)
            case .failure(let error):
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
}
