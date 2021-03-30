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
    
    func setCharacterImage() {
        if let url = URL(string: character.image) {
            ImageService.loadImage(fromUrl: url) {
                [weak self] image in
                self?.delegate?.didLoadCharacterImage(image: image)
            }
        }
    }
    
    var characterName: String {
        return character.name
    }
    
    var characterLocation: String {
        return character.location.name
    }
    
    var characterFirstEpisode: String {
        guard character.episodes != nil, !character.episodes!.isEmpty else {
            return ""
        }
        return character.episodes![0].name
    }
    
    var characterStatus: String {
        return character.status
    }
    
    // MARK: - Private
    private var character: CharacterModel
}
