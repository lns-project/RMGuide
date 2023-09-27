//
//  EpisodeViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 30.08.2023.
//

import UIKit

class EpisodeViewController: UITableViewController {
    
    private var episodeList: [RMEpisode] = []
    private let networkManager = NetworkManager.shared
    private let cellIdentifier = "cell"
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "EPISODES"
        setupUI()
        fetchEpisodes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let episodeList = episodeList[indexPath.row].name {
            cell.textLabel?.text = episodeList
        }
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let episodeUrl = episodeList[indexPath.row].url {
            let destination = EpisodeDetailViewController(episodeLink: episodeUrl)
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == episodeList.count-1,
           episodeList.count == currentPage*networkManager.itemsCount {
            currentPage += 1
            if let urlLink = URL(string: "\(Link.episodeURL.url)/?page=\(currentPage)") {
                NetworkManager.shared.fetch(RMEpisodeInfo.self,
                                            from: urlLink) {
                    [weak self] result in
                    switch result {
                    case .success(let moreEpisodes):
                        if let result = moreEpisodes.results {
                            self?.episodeList.append(contentsOf: result)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.0)
    }
}

extension EpisodeViewController {
    func fetchEpisodes() {
        NetworkManager.shared.fetch(RMEpisodeInfo.self, from: Link.episodeURL.url) { [weak self] result in
            switch result {
            case .success(let episodes):
                if let result = episodes.results {
                    self?.episodeList = result
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
