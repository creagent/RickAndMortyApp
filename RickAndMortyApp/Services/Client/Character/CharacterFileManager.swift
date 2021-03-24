//
//  CharacterFileManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

struct CharacterFileManager {
    // MARK: - Public
    func loadCharacterListFromFile(fileName: String, completion: @escaping (Result<CharacterListModel, Error>) -> Void) {
        FileSystemManager.loadFromFile(fileName: fileName, completion: completion)
    }
    
    func saveCharcterListToFile(characters: [CharacterModel], fileName: String) {
        let characterList = CharacterListModel(characters: characters)
        FileSystemManager.saveToFile(data: characterList, fileName: fileName)
    }
}
