//
//  CharacterViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 17.08.2023.
//

import UIKit

class CharacterViewController: UITableViewController {
    
    private var characterList: [RMCharacter] = []
    private let networkManager = NetworkManager.shared
    private let cellIdentifier = "cell"
    private var currentPage = 1

    private var filteredCharacterList: [RMCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CHARACTERS"
        setupUI()
        //setupSearchBar()
        fetchCharacters()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characterList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CharacterCell {
            cell.configure(with: characterList[indexPath.row])
            cell.cellDelegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor(red: 32/255, green: 35/255, blue: 41/255, alpha: 1.0)
        
        if indexPath.row == characterList.count-1,
           characterList.count == currentPage*networkManager.itemsCount {
            currentPage += 1
            if let urlLink = URL(string: "\(Link.charactersURL.url)/?page=\(currentPage)") {
                NetworkManager.shared.fetch(RMCharacterInfo.self,
                                            from: urlLink) {
                    [weak self] result in
                    switch result {
                    case .success(let moreCharacters):
                        if let result = moreCharacters.results {
                            self?.characterList.append(contentsOf: result)
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                    case .failure(let error):
                        print(error)
                        self?.showAlert(withStatus: .failed)
                    }
                }
            }
            
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
    
    private func setupUI() {
        tableView.register(CharacterCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 217/255, green: 193/255, blue: 74/255, alpha: 1.0)
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
            searchController.delegate = self as? UISearchControllerDelegate
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.searchBar.delegate = self as? UISearchBarDelegate

            let searchBar = searchController.searchBar
            searchBar.tintColor = UIColor.white
            searchBar.barTintColor = UIColor.white

            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
    }
}

extension CharacterViewController {
    func fetchCharacters() {
        NetworkManager.shared.fetch(RMCharacterInfo.self, from: Link.charactersURL.url) { [weak self] result in
            switch result {
            case .success(let characters):
                if let result = characters.results {
                    self?.characterList = result
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } else {
                    self?.showAlert(withStatus: .failed)
                }
            case .failure(let error):
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
}

extension CharacterViewController: ItemTapDelegate {
    
    func didTap(character: RMCharacter) {
        let vc = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapLocation(character: RMCharacter) {
        guard let locationUrl = character.location?.url,
              character.location?.name != "unknown" else { return }
        
        let vc = LocationDetailViewController(location: locationUrl)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapEpisode(character: RMCharacter) {
        if let episodeUrl = character.episode?.first {
            let vc = EpisodeDetailViewController(episodeLink: episodeUrl)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
