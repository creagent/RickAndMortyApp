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
    let nextPageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case count
        case pages
        case nextPageUrl = "next"
    }
}

enum HTTPMethod {
    case get, post, put, delete
}

// Struct for managing network requests
struct NetworkManager {
    // MARK: - Public
    static let urlSession = URLSession.init(configuration: .ephemeral)
    
    static func request(with endPoint: EndPoint, completion: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        guard let url = endPoint.urlComponents.url else {
            print("\n\n\ninvalidURL\n\n\n")
            completion(.failure(.invalidURL))
            return
        }
        
        urlSession.dataTask(with: url) {
            switch $0 {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
                    print("\n\n\ninvalidResponse\n\n\n")
                    completion(.failure(.invalidResponse))
                    return
                }
                print("\(#function) HTTP-Request: " + url.absoluteString)
                completion(.success(data))
            case .failure( _):
                print("\n\n\nAPI error\n\n\n")
                completion(.failure(.apiError))
            }
        }.resume()
    }
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
            print(response)
        }
    }
}
