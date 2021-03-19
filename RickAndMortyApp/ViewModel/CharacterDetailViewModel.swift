//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 19.03.2021.
//

import Foundation
import UIKit

class CharacterDetailViewModel: CharacterDetailDelegate {
    
    // MARK: - Public
    
    init(character: CharacterModel) {
        self.character = character
    }
    
    func setCharacterImage(for imageView: UIImageView) {
        if let url = URL(string: character.imageUrl) {
            imageView.load(url: url)
        }
    }
    
    // MARK: - Readonly
    
    private(set) var character: CharacterModel
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
