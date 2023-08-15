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
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
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
        print("=")
    }
    
    private func fetchLocation() {
        print("==")
    }
    
    private func fetchEpisode() {
        print("===")
    }
}
