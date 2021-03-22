//
//  ListTableViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit

class CharacterListTVController: UITableViewController {
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredCharacters.count
        }
        return viewModel.characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let characterCell = cell as? CharacterListTableViewCell {
            var character: CharacterModel
            if isFiltering {
                character = viewModel.filteredCharacters[indexPath.row]
            }
            else {
                character = viewModel.characters[indexPath.row]
            }
            characterCell.accessoryType = .disclosureIndicator
            characterCell.setData(for: character)
            
            return characterCell
        }
        return cell
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = listRefreshControl
        
        bindToViewModel()
        viewModel.refreshCharacterList()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Navigation    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let destinationVC = segue.destination as? CharacterDetailViewController
            destinationVC?.viewModel = viewModel.characterDetailViewModel(atIndex: indexPath.row)
        }
    }
    
    // MARK: - Private constants
    private let viewModel = CharacterListViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Private
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
            tableView.refreshControl = listRefreshControl
        }
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - Private functions
    private func bindToViewModel() {
        viewModel.didUpdate = {
            [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.didFailInternetConnection = {
            [weak self] in
            DispatchQueue.main.async {
                self?.showNoInternetConnectionAlert()
            }
        }
        
        viewModel.isFiltering = {
            [weak self] in
            return self?.isFiltering ?? false
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
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.refreshCharacterList()
        sender.endRefreshing()
    }
    
    private let listRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
}

// MARK: - UISearchResultsUpdating
extension CharacterListTVController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        viewModel.filterCharacters(searchText: searchText)
        tableView.reloadData()
    }
}
