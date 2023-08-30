//
//  CharacterDetailViewController.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 21.08.2023.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    
    private var characterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var characterTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        return label
    }()
    
    private var statusTemplate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var speciesTemplate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var genderTemplate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var originTemplate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var episodeTemplate: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 48/255, green: 46/255, blue: 86/255, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        return button
    }()
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var speciesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var originLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let statusStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private let speciesStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private let genderStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private let originStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .leading
        return view
    }()
    
    private let descriptionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 15
        return view
    }()
    
    var episodesButtonHide = false
    var character: RMCharacter!
    
    init(character: RMCharacter) {
        super.init(nibName: nil, bundle: nil)
        self.character = character
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showEpisodesPressed(_ sender: UIButton) {
        if let episodeList = character.episode,
           let characterName = character.name {
            let destination = EpisodeListViewController(episodeList: episodeList,
                                                        characterName: characterName)
            navigationController?.pushViewController(destination, animated: true)
            navigationItem.backBarButtonItem = UIBarButtonItem(
                title: "\(characterName)", style: .plain, target: nil, action: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configueView()
        view.backgroundColor = UIColor(red: 60/255, green: 62/255, blue: 68/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        episodeTemplate.isHidden = episodesButtonHide
    }
    
    private func setImage() {
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
    
    private func configueView() {
        setImage()
        characterImage.layer.cornerRadius = 10
        characterTitle.text = character.name
        statusTemplate.text = "Status: "
        speciesTemplate.text = "Species: "
        genderTemplate.text = "Gender: "
        originTemplate.text = "Origin location: "
        
        episodeTemplate.setTitle("Show list of episodes", for: .normal)
        episodeTemplate.addTarget(self, action: #selector(showEpisodesPressed), for: .touchUpInside)
        
        if let status = character.status {
            statusLabel.text = status
        }
        if let species = character.species {
            speciesLabel.text = species
        }
        if let gender = character.gender {
            genderLabel.text = gender
        }
        if let origin = character.origin?.name {
            originLabel.text = origin
        }
    }
    
    private func setupUI() {
        
        view.addSubview(characterTitle)
        view.addSubview(characterImage)
        view.addSubview(descriptionStackView)
        view.addSubview(episodeTemplate)
        
        statusStackView.addArrangedSubview(statusTemplate)
        statusStackView.addArrangedSubview(statusLabel)
        speciesStackView.addArrangedSubview(speciesTemplate)
        speciesStackView.addArrangedSubview(speciesLabel)
        genderStackView.addArrangedSubview(genderTemplate)
        genderStackView.addArrangedSubview(genderLabel)
        originStackView.addArrangedSubview(originTemplate)
        originStackView.addArrangedSubview(originLabel)
        descriptionStackView.addArrangedSubview(statusStackView)
        descriptionStackView.addArrangedSubview(speciesStackView)
        descriptionStackView.addArrangedSubview(genderStackView)
        descriptionStackView.addArrangedSubview(originStackView)
        
        NSLayoutConstraint.activate([
            characterTitle.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 100),
            characterTitle.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            characterTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            characterImage.widthAnchor.constraint(equalToConstant: 200),
            characterImage.heightAnchor.constraint(equalToConstant: 200),
            characterImage.topAnchor.constraint(lessThanOrEqualTo: characterTitle.bottomAnchor, constant: 20),
            characterImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionStackView.topAnchor.constraint(lessThanOrEqualTo: characterImage.bottomAnchor, constant: 20),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionStackView.widthAnchor.constraint(equalToConstant: view.frame.width-20),
            statusLabel.leadingAnchor.constraint(equalTo: statusTemplate.trailingAnchor, constant: 5),
            speciesLabel.leadingAnchor.constraint(equalTo: speciesTemplate.trailingAnchor, constant: 5),
            originLabel.leadingAnchor.constraint(equalTo: originTemplate.trailingAnchor, constant: 0),
            episodeTemplate.topAnchor.constraint(lessThanOrEqualTo: descriptionStackView.bottomAnchor, constant: 40),
            episodeTemplate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            episodeTemplate.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ]
        )
    }
}

