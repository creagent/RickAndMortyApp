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
        //        characterAPIManager.getFilteredByNameCharacters(searchText: searchText) {
        //            [weak self] in switch $0 {
        //            case .success(let characters):
        //                self?.filteredCharacters = characters
        //                print(characters)
        //                self?.didUpdate?()
        //                self?.setEpisodeNameForCharacterList(fromStartingIndex: 0)
        //            case .failure(let error):
        //               print(error)
        //            }
        //        }
        
//        let method = "character/?name=\(searchText)"
//        currentPage += 1
//        characterAPIManager.getCharactersByPageNumber(pageNumber: currentPage, method: method) {
//            [weak self] in switch $0 {
//            case .success(let characters):
//                self?.filteredCharacters = characters
//                print(characters)
//                self?.didUpdate?()
//                self?.setEpisodeNameForCharacterList(fromStartingIndex: 0)
//            case .failure(let error):
//                self?.filteredCharacters = []
//                self?.didUpdate?()
//                print(error)
//            }
//        }
        self.searchText = searchText
        loadCharacterList()
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
    
    func loadNextPageCharacters() {
        refreshDispatchGroup.enter()
        currentPage += 1
        var method = "character"
        if isFiltering {
            method += "/?name=\(searchText)"
        }
        if currentPage <= numberOfCharacterPages {
            self.characterAPIManager.getCharactersByPageNumber(pageNumber: currentPage, method: method) {
                [weak self] in switch $0 {
                case .success(let characters):
                    guard let self = self else {
                        return
                    }
                    var oldCharactersCount: Int
                    if self.isFiltering {
                        oldCharactersCount = self.filteredCharacters.count
                        self.filteredCharacters += characters
                    }
                    else {
                        oldCharactersCount = self.characters.count
                        self.characters += characters
                    }
                    if oldCharactersCount != 0 {
                        self.setEpisodeNameForCharacterList(fromStartingIndex: oldCharactersCount)
                    }
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
            self?.refreshDispatchGroup.leave()
            }
        }
    }
    
    func refrechCharacterList() {
        isRefreshing = true
        loadCharacterList()
    }
    
    func loadCharacterList() {
        if isFiltering {
            filteredCharacters = []
        }
        else if isRefreshing {
            characters = []
            isRefreshing = false
        }
        didUpdate?()
        currentPage = 0
        characterAPIManager.getNumberOfCharacterPages(isFiltering: isFiltering, searchText: searchText) {
            [weak self] in
            switch $0 {
            case .success(let pages):
                self?.numberOfCharacterPages = pages
            case .failure(let error):
                print(error)
            }
        }
        loadNextPageCharacters()
        refreshDispatchGroup.enter()
        loadAllEpisodes()
        refreshDispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            [weak self] in
            self?.setEpisodeNameForCharacterList(fromStartingIndex: 0)
        }
    }
    
    func setEpisodeNameForCharacterList(fromStartingIndex: Int) {
        if !urlToEpisodeNameDict.isEmpty {
            var newCharacters: [CharacterModel]
            if isFiltering {
                newCharacters = filteredCharacters
            }
            else {
                newCharacters = characters
            }
            for i in fromStartingIndex..<newCharacters.count {
                var character = newCharacters[i]
                character.firstEpisode = urlToEpisodeNameDict[character.firstEpisode] ?? "Unknown"
                newCharacters[i] = character
            }
            if isFiltering {
                filteredCharacters = newCharacters
            }
            else {
                characters = newCharacters
            }
            didUpdate?()
            
            if !isFiltering {
                characterFileManager.saveCharcterListToFile(characters: characters, fileName: JSON_FILE_NAME)
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
    
    private let refreshDispatchGroup = DispatchGroup()
    
    // MARK: - Private
    private var urlToEpisodeNameDict: [String: String] = [:]
    
    private var currentPage = 0
    
    private var isRefreshing = false
    
    private var searchText = ""
    
    private var numberOfCharacterPages = 1
    
    // MARK: - Private functions
    private func loadAllEpisodes() {
        self.episodeAPIManager.getAllEpisodes() {
            [weak self] in switch $0 {
            case .success(let episodes):
                guard let self = self else {
                    return
                }
                episodes.forEach {
                    (item) in self.urlToEpisodeNameDict[item.url] = item.name
                }
            case .failure(let error):
                print(error)
                self?.didFailInternetConnection?()
            }
            self?.refreshDispatchGroup.leave()
        }
    }
 }
 
