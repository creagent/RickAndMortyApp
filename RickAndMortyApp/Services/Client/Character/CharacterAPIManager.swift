//
//  CharacterAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

enum CharacterEndPoint: EndPoint {
    case character(page: Int? = nil, name: String? = nil)
    
    var queryParameters: [String : Any] {
        let parameters: [String : Any]
        switch self {
        case .character(let page, let name) where name != nil && page != nil:
            parameters = [
                "name": name!,
                "page": page!
            ]
        case .character(_, let name) where name != nil:
            parameters = [
                "name": name!
            ]
        case .character(let page, _) where page != nil:
            parameters = [
                "page": page!
            ]
        default:
            parameters = [:]
        }
        return parameters
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .character:
            return .get
        }
    }
    
    var APImethod: String {
        return "character"
    }
}

// Struct contains methods to request character information from API and loading/saving
// it from/to file
struct CharacterAPIManager {
    // MARK: - Public
    func getCharacters(page: Int? = nil, name: String? = nil, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        let characterEndPoint: CharacterEndPoint = .character(page: page, name: name)
        NetworkManager.request(with: characterEndPoint) {
            switch $0 {
            case .success(let data):
                if let infoModel: InfoModel<CharacterModel> = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(infoModel.results))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getNumberOfCharacterPages(name: String? = nil , completion: @escaping (Result<Int, Error>) -> Void) {
        let characterEndPoint: CharacterEndPoint = .character(name: name)
        NetworkManager.request(with: characterEndPoint) {
            switch $0 {
            case .success(let data):
                if let infoModel: InfoModel<CharacterModel> = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(infoModel.info.pages))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
