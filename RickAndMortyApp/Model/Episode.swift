//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.02.2021.
//

import Foundation



// Struct for representing episode list response
struct EpisodeInfoModel: Decodable {
    let info: Info
    let results: [EpisodeModel]
}



// Struct for decoding json representation of character's first appearance episode
struct EpisodeModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case episode
        case characters
        case url
        case created
        case airDate = "air_date"
    }
}



// Struct contains methods to request episode information
struct Episode {
    
    // MARK: - Public
    
    init(client: Client) {}
    
    func getEpisodeByURL(url: String, completion: @escaping (Result<EpisodeModel, Error>) -> Void) {
        NetworkManager.requestByUrl(url: url) {
            switch $0 {
            case .success(let data):
                if let episode: EpisodeModel = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(episode))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAllEpisodes(completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        var allEpisodes = [EpisodeModel]()
        
        NetworkManager.requestByMethod(method: "episode") {
            result in switch result {
            case .success(let data):
                if let infoModel: EpisodeInfoModel = JSONHandler.decodeJSONData(data: data) {
                    allEpisodes = infoModel.results
                    let episodesDispatchGroup = DispatchGroup()
                    
                    for index in 2...infoModel.info.pages {
                        episodesDispatchGroup.enter()
                        
                        self.getEpisodesByPageNumber(pageNumber: index) { result in
                            switch result {
                            case .success(let episodes):
                                allEpisodes.append(contentsOf:episodes)
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
    
    // MARK: - Private functions
    
    private func getEpisodesByPageNumber(pageNumber: Int, completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        NetworkManager.requestByMethod(method: "episode/"+"?page="+String(pageNumber)) {
            result in switch result {
            case .success(let data):
                if let infoModel: EpisodeInfoModel = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(infoModel.results))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
