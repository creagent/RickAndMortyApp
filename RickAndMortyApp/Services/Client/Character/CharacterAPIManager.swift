//
//  CharacterAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

enum CharacterEndPoint: EndPoint {
    case character(page: Int? = nil, name: String? = nil, filters: [Filter]? = nil)
    
    var queryParameters: [String : Any?] {
        var parameters: [String : Any?] = [:]
        switch self {
        case .character(let page, let name, let filters):
            parameters = ["name": name]
            if let filters = filters {
                filters.forEach {
                    parameters.merge($0.filterDict)
                }
            }
            parameters["page"] = page
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
    func getCharacterInfoModel(page: Int? = nil, name: String? = nil, filters: [Filter]? = nil, completion: @escaping (Result<InfoModel<CharacterModel>, Error>) -> Void) -> URLSessionDataTask? {
        let characterEndPoint: CharacterEndPoint = .character(page: page, name: name, filters: filters)
        let dataTask = NetworkManager.request(with: characterEndPoint) {
            switch $0 {
            case .success(let data):
                if let infoModel: InfoModel<CharacterModel> = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(infoModel))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return dataTask
    }
}
