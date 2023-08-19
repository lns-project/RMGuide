//
//  CharacterCell.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 18.08.2023.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    private let networkManager = NetworkManager.shared
    
    private let characterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var characterTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .white
        view.font = .systemFont(ofSize: 20, weight: .heavy)
        return view
    }()
    
    private var characterStat: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    private var characterLastLocation: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    private var characterFirstEpisode: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        return view
    }()
    
    private let descriptionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        view.backgroundColor = UIColor(red: 60/255, green: 62/255, blue: 68/255, alpha: 1.0)
        return view
    }()
    
    private let nameStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.layer.cornerRadius = 15
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with character: RMCharacter) {
        
        characterTitle.text = character.name
        
        if let status = character.status, let gender = character.gender {
            characterStat.text = "\(status) - \(gender)"
        }
        
        if let location = character.location?.name {
            characterLastLocation.text = "Last known location: \(location)"
        }
        
        if let episode = character.episode?.first {
            characterFirstEpisode.text = "First seen in: \(episode)"
        }
        
        guard let image = character.image else { return }
        networkManager.fetchImage(from: image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.characterImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(characterImage)
        stackView.addArrangedSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(nameStackView)
        nameStackView.addArrangedSubview(characterTitle)
        nameStackView.addArrangedSubview(characterStat)
        descriptionStackView.addArrangedSubview(characterLastLocation)
        descriptionStackView.addArrangedSubview(characterFirstEpisode)
        
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            characterImage.heightAnchor.constraint(equalToConstant: 150),
            characterImage.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
