//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 19.03.2021.
//

import Foundation
import UIKit

protocol CharacterDetailViewModelDelegate: class {
    func didLoadCharacterImage(image: UIImage)
}

class CharacterDetailViewModel {
    // MARK: - Public
    init(character: CharacterModel) {
        self.character = character
    }
    
    weak var delegate: CharacterDetailViewModelDelegate?
    
    func setCharacterImage(for imageView: UIImageView) {
        if let url = URL(string: character.imageUrl) {
            loadCharacterImage(url: url)
        }
    }
    
    // MARK: - Readonly
    private(set) var character: CharacterModel
    
    // MARK: - Private functions
    func loadCharacterImage(url: URL) {
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self?.delegate?.didLoadCharacterImage(image: image)
                }
            }
        }
    }
}
