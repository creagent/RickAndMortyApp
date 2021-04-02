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
        self.searchText = searchText
        isFiltering = true
        loadCharacterList()
    }
    
    func setFilters(withFilters filters: [Filter]) {
        self.filters = filters
    }
    
    func getFilterListViewModel() -> FilterListViewModel{
        let viewModel = FilterListViewModel()
        viewModel.setFilters(withFilters: filters)
        return viewModel
    }
    
    func locationText(forCharacterAtIndex index: Int) -> String {
        return isFiltering ? filteredCharacters[index].location.name : characters[index].location.name
    }
    
    func nameText(forCharacterAtIndex index: Int) -> String {
        return isFiltering ? filteredCharacters[index].name : characters[index].name
    }
    
    func firstEpisodeText(forCharacterAtIndex index: Int) -> String {
        let characters: [CharacterModel]
        if isFiltering {
            characters = filteredCharacters
        }
        else {
            characters = self.characters
        }
        guard characters[index].episodes != nil, !characters[index].episodes!.isEmpty else {
            return ""
        }
        return characters[index].episodes![0].name
    }
    
    func statusText(forCharacterAtIndex index: Int) -> String {
        return isFiltering ? filteredCharacters[index].status : characters[index].status
    }
    
    var numberOfCharactersToShow: Int {
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
        var name: String? = nil
        if isFiltering {
            name = searchText
        }
        if currentPage <= numberOfCharacterPages {
            self.characterAPIManager.getCharacters(page: currentPage, name: name, filters: filters) {
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
                        case .success(let characters):
                            guard let self = self else {
                                return
                            }
                            self.characters = characters
                            self.didUpdate?()
                            self.setEpisodeNameForCharacterList(fromStartingIndex: 0)
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
    
    // MARK: - Private constants
    private let characterAPIManager = CharacterAPIManager()
    
    private let characterFileManager = CharacterFileManager()
    
    private let episodeAPIManager = EpisodeAPIManager()
    
    private let JSON_FILE_NAME = "characters.json"
    
    private let refreshDispatchGroup = DispatchGroup()
    
    // MARK: - Private
    private var filters: [Filter] = CharacterFilterFactory.getAllCharacterFilters()
    
    private var characters: [CharacterModel] = []
    
    private var filteredCharacters: [CharacterModel] = []
    
    private var allEpisodes: [EpisodeModel] = []
    
    private var currentPage = 0
    
    private var isRefreshing = false
    
    private var searchText = ""
    
    private var numberOfCharacterPages = 1
    
    // MARK: - Private functions
    private func loadCharacterList() {
        if isFiltering {
            filteredCharacters = []
        }
        else if isRefreshing {
            characters = []
            isRefreshing = false
        }
        didUpdate?()
        currentPage = 0
        characterAPIManager.getNumberOfCharacterPages(name: searchText) {
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
    
    private func loadAllEpisodes() {
        self.episodeAPIManager.getAllEpisodes { [weak self] in
            switch $0 {
            case .success(let episodes):
                guard let self = self else {
                    return
                }
                self.allEpisodes = episodes
            case .failure(let error):
                print(error)
                self?.didFailInternetConnection?()
            }
            self?.refreshDispatchGroup.leave()
        }
    }
    
    private func setEpisodeNameForCharacterList(fromStartingIndex: Int) {
        if !allEpisodes.isEmpty {
            var newCharacters: [CharacterModel]
            if isFiltering {
                newCharacters = filteredCharacters
            }
            else {
                newCharacters = characters
            }
            for i in fromStartingIndex..<newCharacters.count {
                var character = newCharacters[i]
                for j in 0..<character.episodeUrls.count {
                    let episodeUrl = character.episodeUrls[j]
                    guard let idString = episodeUrl.split(separator: "/").last else {
                        continue
                    }
                    guard let id = Int(idString) else {
                        continue
                    }
                    // Episodes indecies start from 1 but array starst from 0
                    if character.episodes == nil {
                        character.episodes = []
                    }
                    character.episodes?.append(allEpisodes[id - 1])
                }
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
    
 }
 
