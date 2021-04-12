//
//  LoadAllEpisodesOperation.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 07.04.2021.
//

import Foundation

class LoadEpisodesOperation: AsyncOperation {
    // MARK: - Public
    init(character: CharacterModel) {
        self.character = character
    }
    
    override func main() {
        guard !isCancelled else { return }
        print("\n\n\nEpisodes loading...\n\n\n")
        let idList = self.getEpisodesId(forCharacter: character)
        let episodeAPIManager = EpisodeAPIManager()
        dataTask = episodeAPIManager.getEpisodes(withId: idList) { [weak self] in
            switch $0 {
            case .success(let episodes):
                guard let self = self else {
                    return
                }
                self.character.episodes = episodes
            case .failure(let error):
                print(error)
            }
            print("\n\n\nEpisodes loaded!\n\n\n")
            self?.state = .finished
        }
    }
    
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: - Private
    private var character: CharacterModel
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Private functions
    private func getEpisodesId(forCharacter character: CharacterModel) -> [Int] {
        var idList: [Int] = []
        character.episodeUrls.forEach {
            guard let url = URL(string: $0), let id = Int(url.lastPathComponent) else {
                return
            }
            idList.append(id)
        }
        return idList
    }
}
