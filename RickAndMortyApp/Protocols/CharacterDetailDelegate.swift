//
//  CharacterDetailDelegate.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 19.03.2021.
//

import Foundation
import UIKit

protocol CharacterDetailDelegate {
    
    // MARK: - Public
    
    var character: CharacterModel { get }
    
    func setCharacterImage(for imageView: UIImageView)
}
