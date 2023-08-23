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
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var characterTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.boldSystemFont(ofSize: 20.0)
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.backgroundColor = .red
        view.spacing = 10
        return view
    }()
    
    var character: RMCharacter!
    
//    init(character: RMCharacter) {
//        self.character = character
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configueView()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
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
        characterTitle.text = character.name
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(characterImage)
        stackView.addArrangedSubview(characterTitle)
        stackView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
                                    )
    }
}

