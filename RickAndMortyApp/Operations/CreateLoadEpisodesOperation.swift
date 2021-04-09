//
//  CreateLoadEpisodesOperation.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 07.04.2021.
//
 
import Foundation

class CreateLoadEpisodesOperation: Operation {
    // MARK: - Public
    override func main() {
        guard !isCancelled, dependencies.allSatisfy({!$0.isCancelled}) else { return }
        guard let getCharactersOperation = dependencies.first as? GetCharactersInfoModelOperation else {
            return
        }
        guard let characters = getCharactersOperation.characters else {
            return
        }
        print("\n\n\nCreating load episodes operations...\n\n\n")
        let operationQueue = OperationQueue()
        var operations: [Operation] = []
        for i in 0..<characters.count {
            let episodeOperation = LoadEpisodesOperation(character: characters[i])
            operations.append(episodeOperation)
        }
        operationQueue.addOperations(operations, waitUntilFinished: true)
    }
}
