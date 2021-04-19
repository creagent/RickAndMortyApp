//
//  CreateLoadEpisodesOperation.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 07.04.2021.
//
 
import Foundation

class CreateLoadEpisodesOperation: Operation {
    // MARK: - Public
    init(characters: [CharacterModel]) {
        self.characters = characters
    }
    
    override func main() {
        guard !isCancelled else { return }
        print("\n\n\nCreating load episodes operations...\n\n\n")
        let operationQueue = OperationQueue()
        var operations: [Operation] = []
        for i in 0..<characters.count {
            let episodeOperation = LoadEpisodesOperation(character: characters[i])
            operations.append(episodeOperation)
        }
        operationQueue.addOperations(operations, waitUntilFinished: true)
    }
    
    private let characters: [CharacterModel]
}
