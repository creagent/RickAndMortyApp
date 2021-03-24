 //
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 19.03.2021.
//

import Foundation

class CharacterListViewModel {
    // MARK: - Public
    var didUpdate: (() -> Void)?
    
    var didFailInternetConnection: (() -> Void)?
    
    var isFiltering: Bool = false
    
    func filterCharacters(searchText: String) {
        filteredCharacters = characters.filter {
            $0.name.contains(searchText)
        }
    }
    
    func locationText(forCharacterAtIndex index: Int) -> String {
        return isFiltering ? filteredCharacters[index].location : characters[index].location
    }
    
    func nameText(forCharacterAtIndex index: Int) -> String {
        return isFiltering ? filteredCharacters[index].name : characters[index].name
    }
    
    func firstEpisodeText(forCharacterAtIndex index: Int) -> String {
        return isFiltering ? filteredCharacters[index].firstEpisode : characters[index].firstEpisode
    }
    
    func statusText(forCharacterAtIndex index: Int) -> String {
        return isFiltering ? filteredCharacters[index].status : characters[index].status
    }
    
    func numberOfCharactersToShow() -> Int {
        if isFiltering {
            return filteredCharacters.count
        }
        return characters.count
    }
    
    func characterDetailViewModel(atIndex index: Int) -> CharacterDetailViewModel {
        var character: CharacterModel

        if isFiltering {
            character = filteredCharacters[index]
        } else {
            character = characters[index]
        }
        return CharacterDetailViewModel(character: character)
    }
    
    func refreshCharacterList() {
        self.characterAPIManager.getAllCharacters {
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
                self.characterFileManager.loadCharacterListFromFile(fileName: self.JSON_FILE_NAME) {
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
        self.episodeAPIManager.getAllEpisodes() {
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
                
                self.characterFileManager.saveCharcterListToFile(characters: self.characters, fileName: self.JSON_FILE_NAME)
            case .failure(let error):
                print(error)
                self?.didFailInternetConnection?()
            }
        }
    }
    
    // MARK: - Readonly
    private(set) var characters: [CharacterModel] = []
    
    private(set) var filteredCharacters: [CharacterModel] = []
    
    // MARK: - Private constants
    private let characterAPIManager = CharacterAPIManager()
    
    private let characterFileManager = CharacterFileManager()
    
    private let episodeAPIManager = EpisodeAPIManager()
    
    private let JSON_FILE_NAME = "characters.json"
    
    // MARK: - Private
    private var urlToEpisodeNameDict: [String: String] = [:]
}
