//
//  FileManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 23.02.2021.
//

import Foundation

// Struct for managing JSON read/write file operations
struct FileSystemManager {
    // MARK: - Public
    static func loadFromFile<T: Decodable>(fileName: String, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileManager = FileManager.default
            guard let docDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let inputFileURL = docDirectoryURL.appendingPathComponent(fileName)
            guard fileManager.fileExists(atPath: inputFileURL.path) else {
                return
            }
            do {
                let inputData = try Data(contentsOf: inputFileURL)
                print("\nFile was read successfully!\n")
                if let decodedData: T = JSONHandler.decodeJSONData(data: inputData) {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    //func foo(args:AnyObject...)
    static func saveToFile<T: Encodable>(data: T, fileName: String) {
        DispatchQueue.global(qos: .background).async {
            guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else {
                return
            }
            let outputURL = docDirectoryURL.appendingPathComponent(fileName)
            do {
                guard let jsonCodedData = JSONHandler.encodeJSONData(data: data) else {
                    return
                }
                try jsonCodedData.write(to: outputURL, options: .atomic)
                print("\nSaved successfully!\n")
            } catch {
                return
            }
        }
    }
}
