//
//  NeyworkHandler.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation

// Enum for categorization of possible network errors
enum NetworkManagerError: Error {
    case invalidURL
    case invalidResponse
    case apiError
    case decodingError
}

// Struct for representing response info
struct Info: Decodable {
    let count: Int
    let pages: Int
}

// Struct for managing network requests
struct NetworkManager {
    // MARK: - Public
    static func requestByMethod(method: String, completion: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        if let url = URL(string: BASE_API_URL + method) {
            let urlSession = URLSession.init(configuration: .ephemeral)
            urlSession.dataTask(with: url) {
                switch $0 {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    print("\(#function) HTTP-Request: " + BASE_API_URL + method)
                    completion(.success(data))
                case .failure( _):
                    completion(.failure(.apiError))
                }
            }.resume()
        } else {
            completion(.failure(.invalidURL))
        }
    }
    
    static func requestByUrl(url: String, completion: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        if let url = URL(string: url) {
            let urlSession = URLSession.init(configuration: .ephemeral)
            urlSession.dataTask(with: url) {
                switch $0 {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    print("\(#function) HTTP-Request: " + url.absoluteString)
                    completion(.success(data))
                case .failure( _):
                    completion(.failure(.apiError))
                }
            }.resume()
        } else {
            completion(.failure(.invalidURL))
        }
    }
    
    // MARK: - Private constants
    private static let BASE_API_URL: String = "https://rickandmortyapi.com/api/"
}

// Extension to implement <Result> type in URLSession.
extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
