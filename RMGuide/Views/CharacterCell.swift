//
//  CharacterCell.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 18.08.2023.
//

import UIKit

protocol ItemTapDelegate: AnyObject {
    func didTap(character: RMCharacter)
    
    func didTapLocation(character: RMCharacter)
    
    func didTapEpisode(character: RMCharacter)
}

class CharacterCell: UITableViewCell {
    
    private let networkManager = NetworkManager.shared
    private var character: RMCharacter?
    weak var cellDelegate: ItemTapDelegate?
    
    @objc func characterPressed(_ sender: UIButton) {
        guard let character = character else { return }
        cellDelegate?.didTap(character: character)
    }
    
    @objc func locationPressed(_ sender: UIButton) {
        guard let character = character else { return }
        cellDelegate?.didTapLocation(character: character)
    }
    
    @objc func episodePressed(_ sender: UIButton) {
        guard let character = character else { return }
        cellDelegate?.didTapEpisode(character: character)
    }
    
    private lazy var characterImage: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var characterTitle: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private var characterStat: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private var characterStatView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private var statStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 5
        return view
    }()
    
    private var characterLastLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var lastLocationTemplate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private var locationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var episodeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var characterFirstEpisode: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var firstEpisodeTemplate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let episodeStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    
    private let descriptionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 2
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
        view.clipsToBounds = true
        return view
    }()
    
    private var spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        spinnerView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with character: RMCharacter) {
        self.character = character
        
        characterTitle.setTitle(character.name, for: .normal)
        
        if let status = character.status, let gender = character.gender {
            characterStatView.backgroundColor = statBackgroundColor(characterStat: character)
            characterStat.text = "\(status) - \(gender)"
        }
        
        lastLocationTemplate.text = "Last known location:"
        if let location = character.location?.name {
            characterLastLocation.text = location
        }
        
        firstEpisodeTemplate.text = "First seen in:"
        if let episode = character.episode?.first {
            characterFirstEpisode.text = episode
        }
        
        guard let image = character.image else { return }
        networkManager.fetchImage(from: image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.characterImage.setBackgroundImage(UIImage(data: imageData), for: .normal)
                self?.spinnerView.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
        characterImage.addTarget(self,
                                 action: #selector(self.characterPressed),
                                 for: .touchUpInside)
        characterTitle.addTarget(self,
                                 action: #selector(self.characterPressed),
                                 for: .touchUpInside)
        locationButton.addTarget(self,
                                 action: #selector(self.locationPressed),
                                 for: .touchUpInside)
        episodeButton.addTarget(self,
                                action: #selector(self.episodePressed),
                                for: .touchUpInside)
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(characterImage)
        stackView.addArrangedSubview(descriptionStackView)
        characterImage.addSubview(spinnerView)
        descriptionStackView.addArrangedSubview(nameStackView)
        nameStackView.addArrangedSubview(characterTitle)
        nameStackView.addArrangedSubview(statStackView)
        let containerView = UIView()
        containerView.addSubview(characterStatView)
        statStackView.addArrangedSubview(containerView)
        statStackView.addArrangedSubview(characterStat)
        descriptionStackView.addArrangedSubview(locationStackView)
        locationStackView.addSubview(locationButton)
        locationStackView.addArrangedSubview(lastLocationTemplate)
        locationStackView.addArrangedSubview(characterLastLocation)
        descriptionStackView.addArrangedSubview(episodeStackView)
        episodeStackView.addSubview(episodeButton)
        episodeStackView.addArrangedSubview(firstEpisodeTemplate)
        episodeStackView.addArrangedSubview(characterFirstEpisode)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            characterImage.heightAnchor.constraint(equalToConstant: 160),
            characterImage.widthAnchor.constraint(equalToConstant: 150),
            spinnerView.centerXAnchor.constraint(equalTo: characterImage.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: characterImage.centerYAnchor),
            spinnerView.heightAnchor.constraint(equalTo: characterImage.heightAnchor),
            nameStackView.leftAnchor.constraint(equalTo: descriptionStackView.leftAnchor, constant: 10),
            characterStatView.widthAnchor.constraint(equalToConstant: 10),
            characterStatView.heightAnchor.constraint(equalToConstant: 10),
            containerView.widthAnchor.constraint(equalToConstant: 10),
            characterStatView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            characterStatView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            characterStat.heightAnchor.constraint(equalToConstant: 20),
            locationButton.widthAnchor.constraint(equalToConstant: contentView.frame.width-40),
            episodeButton.widthAnchor.constraint(equalToConstant: contentView.frame.width-40)
        ])
    }
    
    private func statBackgroundColor(characterStat: RMCharacter) -> UIColor {
        let status = characterStat.status
        
        switch status {
        case "Alive": return .green
        case "Dead": return .red
        case "unknown": return .lightGray
        default: return .lightGray
        }
    }
}
