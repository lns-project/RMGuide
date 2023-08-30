//
//  EpisodeListViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 29.08.2023.
//

import UIKit

class EpisodeListViewController: UITableViewController {
    
    var episodeList: [String] = []
    var characterName: String
    private let networkManager = NetworkManager.shared
    private let cellIdentifier = "episodeCell"
    
    init(episodeList: [String], characterName: String) {
        self.episodeList = episodeList
        self.characterName = characterName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let episode = episodeList[indexPath.row]
        cell.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.0)
        cell.textLabel?.text = episode
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        view.textAlignment = .center
        view.contentMode = .center
        view.text = "EPISODES with \(characterName)"
        view.numberOfLines = 0
        view.textColor = .white
        view.font = UIFont.boldSystemFont(ofSize: 20)
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let destination = EpisodeDetailViewController(episodeLink: episodeList[indexPath.row])
        navigationController?.pushViewController(destination, animated: true)
    }
    
    private func setupUI() {
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.0)
    }
}
