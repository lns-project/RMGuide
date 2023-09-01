//
//  LocationDetailViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 30.08.2023.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    var locationLink: String
    private var location: RMLocation?
    private var character: RMCharacter?
    private var tableView: UITableView!
    private let networkManager = NetworkManager.shared
    private let cellIdentifier = "locationCell"
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        return label
    }()
    
    private var dimensionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private var locationTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    init(location: String) {
        self.locationLink = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchLocation()
    }
    
    private func configueView() {
        if let name = location?.name {
            locationLabel.text = name
        }
        if let dimension = location?.dimension, let type = location?.type {
            dimensionLabel.text = "\(type) - \(dimension)"
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.5)
        view.addSubview(locationLabel)
        view.addSubview(dimensionLabel)
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.5)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 100),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dimensionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            dimensionLabel.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            dimensionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: dimensionLabel.bottomAnchor, constant: 20),
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

extension LocationDetailViewController {
    func fetchLocation() {
        if let url = URL(string: locationLink) {
            NetworkManager.shared.fetch(RMLocation.self, from: url) { [weak self] result in
                switch result {
                case .success(let location):
                    self?.location = location
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
}

extension LocationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = 0
        if let charactersList = location?.residents {
            return charactersList.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.0)
        if let characterList = location?.residents {
            cell.textLabel?.text = characterList[indexPath.row]
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let characterInList = location?.residents {
            NetworkManager.shared.fetch(RMCharacter.self,
                                        from: URL(string: characterInList[indexPath.row])!) {
                [weak self] result in
                switch result {
                case .success(let character):
                    DispatchQueue.main.async {
                        let destination = CharacterDetailViewController(character: character)
                        self?.navigationController?.pushViewController(destination, animated: true)
                        if let locationName = self?.location?.name {
                            self?.navigationItem.backBarButtonItem = UIBarButtonItem(
                                title: "\(locationName)", style: .plain, target: nil, action: nil)
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

