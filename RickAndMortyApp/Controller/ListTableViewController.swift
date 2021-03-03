//
//  ListTableViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit



class ListTableViewController: UITableViewController {
    
    private let client = Client()
    
    private var characters: [CharacterModel] = []
    
    private var urlToEpisodeNameDict: [String: String] = [:]
    
    // MARK: - Searchbar properties
    
    private var filteredCharacters: [CharacterModel] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        if searchController.isActive {
            tableView.refreshControl = nil
        }
        else {
            tableView.refreshControl = myRefreshControl
        }
        
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    
    // MARK: - Table view data initializing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = myRefreshControl
        
        initializeCharacterList()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func initializeCharacterList() {
        URLCache.shared.removeAllCachedResponses()
        
        self.client.character().getAllCharacters {
            [weak self] in switch $0 {
            case .success(let characters):
                guard let self = self else {
                    return
                }
                
                self.characters = characters
                self.setEpisodeNameForCharacterList()
                self.tableView.reloadData()
                
            case.failure(let error):
                print(error)
                
                guard let self = self else {
                    return
                }
                
                self.client.character().loadCharacterListFromFile(fileName: "characters.dat") {
                    [weak self] in switch $0 {
                    case .success(let characterList):
                        guard let self = self else {
                            return
                        }
                        
                        self.characters = characterList.characters
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    case.failure(let error):
                        print(error)
                    }
                }
                
                self.showNoInternetConnectionAlert()
            }
        }
    }
    
    private func setEpisodeNameForCharacterList() {
        URLCache.shared.removeAllCachedResponses()
        
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
                
                self.tableView.reloadData()
                
                self.client.character().saveCharcterListToFile(characters: self.characters, fileName: "characters.dat")
                
            case .failure(let error):
                print(error)
                self?.showNoInternetConnectionAlert()
            }
        }
    }
    
    private func showNoInternetConnectionAlert() {
        DispatchQueue.main.async {
            let dialogMessage = UIAlertController(title: "Can't refresh right now", message: "Make sure your device is connected to the internet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            dialogMessage.addAction(ok)
            
            self.present(dialogMessage, animated: true)
        }
    }
    
    // MARK: - Refreshing
    
    @objc func refresh(sender: UIRefreshControl) {
        initializeCharacterList()
        sender.endRefreshing()
    }
    
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCharacters.count
        }
        
        return characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let characterCell = cell as? ListTableViewCell {
            var character: CharacterModel
            
            if isFiltering {
                character = filteredCharacters[indexPath.row]
            }
            else {
                character = characters[indexPath.row]
            }
            
            characterCell.accessoryType = .disclosureIndicator
            characterCell.setData(for: character)
            
            return characterCell
        }
        
        return cell
    }
    
    // MARK: - Detail screen segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            var character: CharacterModel
            if isFiltering {
                character = filteredCharacters[indexPath.row]
            } else {
                character = characters[indexPath.row]
            }
            
            let destinationVC = segue.destination as? DetailViewController
            destinationVC?.character = character
        }
    }
}



// MARK: - Search logic

extension ListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCharacters = characters.filter {
            $0.name.contains(searchText)
        }
        tableView.reloadData()
    }
}
