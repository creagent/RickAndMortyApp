//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation


// Struct for storing character list in file
struct CharacterListModel: Codable {
    let characters: [CharacterModel]
}

// Struct for character's data appropriate form interpretation
struct CharacterModel: Codable {
    let name: String
    let status: String
    let location: String
    let imageUrl: String
    var firstEpisode: String
    
    init(from data: CharacterData) {
        name = data.name
        status = data.status
        location = data.location.name
        imageUrl = data.image
        firstEpisode = data.episode[0]
    }
}



// Struct for decoding character's json representation
struct CharacterData: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOriginModel
    let location: CharacterLocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
}



// Struct contains methods to request character information from API and loading/saving
// it from/to file
struct Character {
    
    init(client: Client) {}
    
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
                                    character in allCharacters.append(CharacterModel(from: character))
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
    
    // Gets all (20) characters from page with given number
    private func getCharactersByPageNumber(pageNumber: Int, completion: @escaping (Result<[CharacterData], Error>) -> Void) {
        NetworkManager.requestByMethod(method: "character/"+"?page="+String(pageNumber)) {
            switch $0 {
            case .success(let data):
                if let infoModel: CharacterInfoModel = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(infoModel.results))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCharacterListFromFile(fileName: String, completion: @escaping (Result<CharacterListModel, Error>) -> Void) {
        FileSystemManager.loadFromFile(fileName: fileName, completion: completion)
    }
    
    func saveCharcterListToFile(characters: [CharacterModel], fileName: String) {
        let characterList = CharacterListModel(characters: characters)
        FileSystemManager.saveToFile(data: characterList, fileName: fileName)
    }
}



// Struct for representing character list response
struct CharacterInfoModel: Decodable {
    let info: Info
    let results: [CharacterData]
}



// Struct for decoding character's origin json info
struct CharacterOriginModel: Decodable {
    let name: String
    let url: String
}



// Struct for decoding character's location json info
struct CharacterLocationModel: Decodable {
    let name: String
    let url: String
}
