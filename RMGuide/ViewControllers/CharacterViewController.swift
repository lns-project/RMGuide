//
//  CharacterViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 17.08.2023.
//

import UIKit

class CharacterViewController: UITableViewController, cellDelegateProtocol {

    private var characterList: [RMCharacter] = []
    private let networkManager = NetworkManager.shared
    private let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CHARACTERS"
        setupUI()
        fetchCharacters()
    }

    // MARK: - Table view data source

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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        let character = characterList[indexPath.row]
//        performSegue(withIdentifier: "detailCharacter", sender: character)
    }
    
    private func showAlert(withStatus status: Alert) {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
    }
    
    func didPressButton(cell: CharacterCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("===\(indexPath.row)")
        }
    }
    private func setupUI() {
        
        tableView.register(CharacterCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 217/255, green: 193/255, blue: 74/255, alpha: 1.0)

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
