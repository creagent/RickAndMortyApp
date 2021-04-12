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
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                let loadCharacterImageOperation = LoadCharacterImageOperation(url: url)
                self.operationQueue.addOperations([loadCharacterImageOperation], waitUntilFinished: true)
                guard let image = loadCharacterImageOperation.image else { return }
                self.delegate?.didLoadCharacterImage(image: image)
            }
        }
    }
    
    func cancelImageLoading() {
        operationQueue.cancelAllOperations()
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
    
    // MARK: - Private constants
    let operationQueue = OperationQueue()
    
    // MARK: - Private
    private var character: CharacterModel
}
