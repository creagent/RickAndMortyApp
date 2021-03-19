//
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 19.03.2021.
//

import Foundation

class CharacterListViewModel {
    
    // MARK: - Public
    
    var filteredCharacters: [CharacterModel] = []
    
    var didUpdate: (() -> Void)?
    
    var didFailInternetConnection: (() -> Void)?
    
    func filterCharacters(searchText: String) {
        filteredCharacters = characters.filter {
            $0.name.contains(searchText)
        }
    }
    
    func refreshCharacterList() {
        self.client.character().getAllCharacters {
            [weak self] in switch $0 {
            case .success(let characters):
                guard let self = self else {
                    return
                }
                
                self.characters = characters
                self.setEpisodeNameForCharacterList()
                
                self.didUpdate?()
                
            case.failure(let error):
                print(error)
                
                guard let self = self else {
                    return
                }
                
                self.client.character().loadCharacterListFromFile(fileName: self.JSON_FILE_NAME) {
                    [weak self] in switch $0 {
                    case .success(let characterList):
                        guard let self = self else {
                            return
                        }
                        
                        self.characters = characterList.characters
                        self.didUpdate?()
                        
                    case.failure(let error):
                        print(error)
                    }
                }
                
                self.didFailInternetConnection?()
            }
        }
    }
    
    func setEpisodeNameForCharacterList() {
        self.client.episode().getAllEpisodes() {
            [weak self] in switch $0 {
            case .success(let episodes):
                guard let self = self else {
                    return
                }
                
                episodes.forEach {
                    (item) in self.urlToEpisodeNameDict[item.url] = item.name
                }
                
                for i in self.characters.indices {
                    var character = self.characters[i]
                    character.firstEpisode = self.urlToEpisodeNameDict[character.firstEpisode] ?? "Unknown"
                    self.characters[i] = character
                }
                
                self.didUpdate?()
                
                self.client.character().saveCharcterListToFile(characters: self.characters, fileName: self.JSON_FILE_NAME)
                
            case .failure(let error):
                print(error)
                self?.didFailInternetConnection?()
            }
        }
    }
    
    // MARK: - Readonly
    
    private(set) var characters: [CharacterModel] = []
    
    // MARK: - Private constants
    
    private let client = Client()
    
    private let JSON_FILE_NAME = "characters.json"
    
    // MARK: - Private
    
    private var urlToEpisodeNameDict: [String: String] = [:]
}
