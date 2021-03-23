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
        if let url = URL(string: character.imageUrl) {
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
        return character.location
    }
    
    var characterFirstEpisode: String {
        return character.firstEpisode
    }
    
    var characterStatus: String {
        return character.status
    }
    
    // MARK: - Private
    private var character: CharacterModel
}
