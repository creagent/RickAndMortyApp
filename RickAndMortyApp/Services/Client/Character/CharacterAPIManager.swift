//
//  CharacterAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

// Struct contains methods to request character information from API and loading/saving
// it from/to file
struct CharacterAPIManager {
    // MARK: - Public
    func getAllCharacters(completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        var allCharacters = [CharacterModel]()
        NetworkManager.requestByMethod(method: "character") {
            switch $0 {
            case .success(let data):
                if let infoModel: CharacterInfoModel = JSONHandler.decodeJSONData(data: data) {
                    infoModel.results.forEach {
                        character in allCharacters.append(CharacterModel(from: character))
                    }
                    let charactersDispatchGroup = DispatchGroup()
                    for index in 2...infoModel.info.pages {
                        charactersDispatchGroup.enter()
                        self.getCharactersByPageNumber(pageNumber: index) {
                            switch $0 {
                            case .success(let characters):
                                characters.forEach {
                                    character in allCharacters.append(character)
                                }
                                charactersDispatchGroup.leave()
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                    charactersDispatchGroup.notify(queue: .main) {
                        completion(.success(allCharacters))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCharactersByPageNumber(pageNumber: Int, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        NetworkManager.requestByMethod(method: "character/"+"?page="+String(pageNumber)) {
            switch $0 {
            case .success(let data):
                if let infoModel: CharacterInfoModel = JSONHandler.decodeJSONData(data: data) {
                    var characters: [CharacterModel] = []
                    infoModel.results.forEach {
                        character in characters.append(CharacterModel(from: character))
                    }
                    completion(.success(characters))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNumberOfCharacterPages(completion: @escaping (Result<Int, Error>) -> Void) {
        NetworkManager.requestByMethod(method: "character") {
            switch $0 {
            case .success(let data):
                if let infoModel: CharacterInfoModel = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(infoModel.info.pages))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
