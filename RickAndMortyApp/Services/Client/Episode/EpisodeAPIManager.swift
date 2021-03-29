//
//  EpisodeAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

enum EpisodeEndPoint: EndPoint {
    case episode(page: Int? = nil)
    
    var queryParameters: [String : Any] {
        let parameters: [String : Any]
        switch self {
        case .episode(let page) where page != nil:
            parameters = [
                "page": String(page!)
            ]
        default:
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
        return "episode"
    }
}

// Struct contains methods to request episode information
struct EpisodeAPIManager {
    // MARK: - Public
    func getAllEpisodes(completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        var episodeEndPoint: EpisodeEndPoint = .episode()
        var allEpisodes = [EpisodeModel]()
        NetworkManager.request(with: episodeEndPoint) { result in
            switch result {
            case .success(let data):
                if let infoModel: EpisodeInfoModel = JSONHandler.decodeJSONData(data: data) {
                    let episodesDispatchGroup = DispatchGroup()
                    for page in 1...infoModel.info.pages {
                        episodesDispatchGroup.enter()
                        episodeEndPoint = .episode(page: page)
                        NetworkManager.request(with: episodeEndPoint) { result in
                            switch result {
                            case .success(let data):
                                if let infoModel: EpisodeInfoModel = JSONHandler.decodeJSONData(data: data) {
                                    infoModel.results.forEach {
                                        episode in allEpisodes.append(episode)
                                    }
                                }
                                episodesDispatchGroup.leave()
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                    episodesDispatchGroup.notify(queue: DispatchQueue.main) {
                        completion(.success(allEpisodes.sorted { $0.id < $1.id }))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
