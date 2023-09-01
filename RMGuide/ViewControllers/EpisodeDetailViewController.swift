//
//  EpisodeDetailViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 29.08.2023.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    
    var episodeLink: String
    private var episode: RMEpisode?
    private var character: RMCharacter?
    private var tableView: UITableView!
    private let networkManager = NetworkManager.shared
    private let cellIdentifier = "episodeCell"
    
    private var episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        return label
    }()
    
    private var episodeNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    init(episodeLink: String) {
        self.episodeLink = episodeLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchEpisode()
    }
    
    private func configueView() {
        if let name = episode?.name {
            episodeLabel.text = name
        }
        if let number = episode?.episode, let airDate = episode?.air_date {
            episodeNumberLabel.text = "\(number) - \(airDate)"
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.5)
        view.addSubview(episodeLabel)
        view.addSubview(episodeNumberLabel)
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.5)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            episodeLabel.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 100),
            episodeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            episodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            episodeNumberLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 20),
            episodeNumberLabel.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            episodeNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: episodeNumberLabel.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ]
        )
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

extension EpisodeDetailViewController {
    func fetchEpisode() {
        NetworkManager.shared.fetch(RMEpisode.self, from: URL(string: episodeLink)!) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.episode = episode
                DispatchQueue.main.async {
                    self?.configueView()
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
}

extension EpisodeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = 0
        if let charactersList = episode?.characters {
            return charactersList.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.0)
        if let characterList = episode?.characters {
            cell.textLabel?.text = characterList[indexPath.row]
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let characterInList = episode?.characters {
            NetworkManager.shared.fetch(RMCharacter.self,
                                        from: URL(string: characterInList[indexPath.row])!) {
                [weak self] result in
                switch result {
                case .success(let character):
                    DispatchQueue.main.async { [weak self] in
                        let destination = CharacterDetailViewController(character: character)
                        destination.episodesButtonHide = true
                        self?.navigationController?.pushViewController(destination, animated: true)
                        if let episodeName = self?.episode?.name {
                            self?.navigationItem.backBarButtonItem = UIBarButtonItem(
                                title: "\(episodeName)", style: .plain, target: nil, action: nil)
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
