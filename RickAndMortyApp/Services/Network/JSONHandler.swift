//
//  JSONHandler.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 23.02.2021.
//

import Foundation

// Helper struct that handles JSON coding/decoding
struct JSONHandler {
    // MARK: - Public
    static func decodeJSONData<T: Decodable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("\(#function) error")
            return nil
        }
    }
    
    static func encodeJSONData<T: Encodable>(data: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(data)
            return encodedData
        } catch {
            print("\(#function) error")
            return nil
        }
    }
}
