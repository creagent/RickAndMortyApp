//
//  CharacterAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

enum CharacterEndPoint: EndPoint {
    case character(page: Int)
    case filteredCharacter(name: String, page: Int)
    
    var queryParameters: [String : String] {
        switch self {
        case .character(let page):
            return [
                "page": String(page)
            ]
        case .filteredCharacter(let name, let page):
            return [
                "name": name,
                "page": String(page)
            ]
        }
    }
    
    var httpMethod: String {
        switch self {
        case .character:
            return "get"
        case .filteredCharacter:
            return "get"
        }
    }
    
    var APImethod: String {
        return "character"
    }
    
    mutating func setPageNumber(pageNumber: Int) {
        switch self {
        case .character:
            self = .character(page: pageNumber)
        case .filteredCharacter(let name, _):
            self = .filteredCharacter(name: name, page: pageNumber)
        }   
    }
}

// Struct contains methods to request character information from API and loading/saving
// it from/to file
struct CharacterAPIManager {
    // MARK: - Public
    func getCharacters(page: Int? = nil, name: String? = nil, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        var characterEndPoint: CharacterEndPoint
        if let page = page, let name = name {
            characterEndPoint = .filteredCharacter(name: name, page: page)
        }
        else if let page = page {
            characterEndPoint = .character(page: page)
        }
        else {
            characterEndPoint = .character(page: 1)
        }
        NetworkManager.request(with: characterEndPoint) {
            switch $0 {
            case .success(let data):
                if let infoModel: CharacterInfoModel = JSONHandler.decodeJSONData(data: data) {
                    var characters = [CharacterModel]()
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

    func getNumberOfCharacterPages(name: String? = nil , completion: @escaping (Result<Int, Error>) -> Void) {
        var characterEndPoint: CharacterEndPoint
        if let name = name {
            characterEndPoint = .filteredCharacter(name: name, page: 1)
        }
        else {
            characterEndPoint = .character(page: 1)
        }
        NetworkManager.request(with: characterEndPoint) {
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
