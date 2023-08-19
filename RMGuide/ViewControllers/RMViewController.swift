//
//  RMViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 15.08.2023.
//

import UIKit

enum UserAction: String, CaseIterable {
    case fetchCharacters = "Characters"
    case fetchLocation = "Location"
    case fetchEpisode = "Episode"
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

class RMViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases
    private let networkManager = NetworkManager.shared
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"background")
        iv.contentMode = .topRight
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundView = imageView
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath) as! UserActionCell
        cell.userActionLabel.text = userActions[indexPath.item].rawValue.uppercased()
        cell.userActionLabel.textColor = UIColor.white
        cell.userActionLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor(red: 31/255, green: 33/255, blue: 64/255, alpha: 1.0).cgColor
        
        switch indexPath.row {
        case 0: cell.backgroundColor = UIColor(red: 217/255, green: 193/255, blue: 74/255, alpha: 1.0)
        case 1: cell.backgroundColor = UIColor(red: 140/255, green: 81/255, blue: 92/255, alpha: 1.0)
        case 2: cell.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.0)
        default: cell.backgroundColor = UIColor(red: 217/255, green: 193/255, blue: 74/255, alpha: 1.0)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .fetchCharacters: performSegue(withIdentifier: "showCharacter", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacter" {
            guard let characterVC = segue.destination as? CharacterViewController else { return }
            characterVC.fetchCharacters()
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
