//
//  CharacterCell.swift
//  RMGuide
//
//  Created by Динара Шарафутдинова on 18.08.2023.
//

import UIKit

protocol ImageTapDelegate: AnyObject {
        func didTap(character: RMCharacter)
    }

class CharacterCell: UITableViewCell {
    
    private let networkManager = NetworkManager.shared
    private var character: RMCharacter?
    weak var cellDelegate: ImageTapDelegate?
    
    @objc func characterPressed(_ sender: UIButton) {
        print("Click")
        guard let character = character else { return }
        cellDelegate?.didTap(character: character)
    }
    
    private lazy var characterImage: UIButton = {
        let view = UIButton()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var characterTitle: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.contentHorizontalAlignment = .left
        return view
    }()
    
    private var characterStat: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .white
        return view
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
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .white
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private var lastLocationTemplate: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private let locationStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private var characterFirstEpisode: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .white
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private var lastEpisodeTemplate: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 15)
        return view
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
        view.clipsToBounds = true
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
        self.character = character
        
        characterTitle.setTitle(character.name, for: .normal)
        
        if let status = character.status, let gender = character.gender {
            characterStatView.backgroundColor = .green
            characterStat.text = "\(status) - \(gender)"
        }
        
        lastLocationTemplate.text = "Last known location:"
        if let location = character.location?.name {
            characterLastLocation.text = location
        }
        
        lastEpisodeTemplate.text = "First seen in:"
        if let episode = character.episode?.first {
            characterFirstEpisode.text = episode
        }
        
        guard let image = character.image else { return }
        networkManager.fetchImage(from: image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.characterImage.setBackgroundImage(UIImage(data: imageData), for: .normal)
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
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(characterImage)
        stackView.addArrangedSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(nameStackView)
        nameStackView.addArrangedSubview(characterTitle)
        nameStackView.addArrangedSubview(statStackView)
        let containerView = UIView()
        containerView.addSubview(characterStatView)
        statStackView.addArrangedSubview(containerView)
        statStackView.addArrangedSubview(characterStat)
        descriptionStackView.addArrangedSubview(locationStackView)
        locationStackView.addArrangedSubview(lastLocationTemplate)
        locationStackView.addArrangedSubview(characterLastLocation)
        descriptionStackView.addArrangedSubview(episodeStackView)
        episodeStackView.addArrangedSubview(lastEpisodeTemplate)
        episodeStackView.addArrangedSubview(characterFirstEpisode)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            characterImage.heightAnchor.constraint(equalToConstant: 150),
            characterImage.widthAnchor.constraint(equalToConstant: 150),
            nameStackView.leftAnchor.constraint(equalTo: descriptionStackView.leftAnchor, constant: 10),
            characterStatView.widthAnchor.constraint(equalToConstant: 10),
            characterStatView.heightAnchor.constraint(equalToConstant: 10),
            containerView.widthAnchor.constraint(equalToConstant: 10),
            characterStatView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            characterStatView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            characterStat.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
//    private func statBackgroundColor(characterStat: RMCharacter) -> UIColor {
//        var status = characterStat.status
//
//        switch status {
//        case "Alive": return .green
//        case "Dead": return .red
//        case "unknown": return .lightGray
//        default: return .lightGray
//        }
//    }
}
