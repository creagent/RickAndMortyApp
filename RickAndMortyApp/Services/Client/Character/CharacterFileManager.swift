//
//  CharacterFileManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

struct CharacterFileManager {
    // MARK: - Public
    func loadCharacterListFromFile(fileName: String, completion: @escaping (Result<
                                    [CharacterModel], Error>) -> Void) {
        FileSystemManager.loadFromFile(fileName: fileName, completion: completion)
    }
    
    func saveCharcterListToFile(characters: [CharacterModel], fileName: String) {
        FileSystemManager.saveToFile(data: characters, fileName: fileName)
    }
}
