//
//  Location.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation



// Struct for representing location list response
struct LocationInfoModel: Decodable {
    let info: Info
    let results: [LocationModel]
}



// Struct for decoding character location's json representation
struct LocationModel: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}



// Struct contains methods to request location information
struct Location {
    
    // MARK: - Public
    
    init(client: Client) {}
    
    func getLocationByURL(url: String, completion: @escaping (Result<LocationModel, Error>) -> Void) {
        NetworkManager.requestByUrl(url: url) {
            switch $0 {
            case .success(let data):
                if let location: LocationModel = JSONHandler.decodeJSONData(data: data) {
                    completion(.success(location))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
