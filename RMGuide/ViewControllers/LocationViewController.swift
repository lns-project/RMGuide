//
//  LocationViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 31.08.2023.
//

import UIKit

class LocationViewController: UITableViewController {
    
    private var locationList: [RMLocation] = []
    private let networkManager = NetworkManager.shared
    private let cellIdentifier = "cell"
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LOCATION"
        setupUI()
        fetchLocation()
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
        tableView.backgroundColor = UIColor(red: 140/255, green: 81/255, blue: 92/255, alpha: 1.0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let locationList = locationList[indexPath.row].name {
            cell.textLabel?.text = locationList
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
        
        if let locationUrl = locationList[indexPath.row].url {
            let destination = LocationDetailViewController(location: locationUrl)
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == locationList.count-1,
           locationList.count == currentPage*networkManager.itemsCount {
            currentPage += 1
            if let urlLink = URL(string: "\(Link.locationURL.url)/?page=\(currentPage)") {
                NetworkManager.shared.fetch(RMLocationInfo.self,
                                            from: urlLink) {
                    [weak self] result in
                    switch result {
                    case .success(let moreLocations):
                        if let result = moreLocations.results {
                            self?.locationList.append(contentsOf: result)
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
}

extension LocationViewController {
    func fetchLocation() {
        NetworkManager.shared.fetch(RMLocationInfo.self, from: Link.locationURL.url) { [weak self] result in
            switch result {
            case .success(let locations):
                if let result = locations.results {
                    self?.locationList = result
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
