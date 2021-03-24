//
//  LocationAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

// Struct contains methods to request location information
struct LocationAPIManager {
    // MARK: - Public
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
