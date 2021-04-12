//
//  EpisodeAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

enum EpisodeEndPoint: EndPoint {
    case episode(episodesId: [Int])
    
    var queryParameters: [String : Any?] {
        let parameters: [String : Any]
        switch self {
        case .episode(_):
            parameters = [:]
        }
        return parameters
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .episode:
            return .get
        }
    }
    
    var APImethod: String {
        var method = "episode"
        switch self {
        case .episode(let episodesId):
            method += "/\(String(describing: episodesId))"
        }
        return method
    }
}

// Struct contains methods to request episode information
struct EpisodeAPIManager {
    // MARK: - Public
    func getEpisodes(withId episodesId: [Int], completion: @escaping (Result<[EpisodeModel], Error>) -> Void) -> URLSessionDataTask? {
        let episodeEndPoint: EpisodeEndPoint = .episode(episodesId: episodesId)
        let dataTask = NetworkManager.request(with: episodeEndPoint) { result in
            switch result {
            case .success(let data):
                if let episodes: [EpisodeModel] = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(episodes))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return dataTask
    }
}
