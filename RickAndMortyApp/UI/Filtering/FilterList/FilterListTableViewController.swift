//
//  TableViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 30.03.2021.
//

import UIKit

class FilterListTableViewController: UITableViewController {
    // MARK: - Public
    var viewModel: FilterListViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfFiltersToShow ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        if let filterCell = cell as? FilterListTableViewCell {
            let index = indexPath.row
            filterCell.filterNameText = viewModel?.filterName(forFilterWithIndex: index)
            filterCell.filterCurrentOptionText = viewModel?.currentFilterOptionValue(forFilterWithIndex: index)
            filterCell.accessoryType = .disclosureIndicator
            
            return filterCell
        }
        return cell
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filters"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(applyAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAction))
        bindToViewModel()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilterOptions" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let destinationVC = segue.destination as? FilterOptionsTableViewController
            destinationVC?.viewModel = viewModel?.filterOptionsViewModel(atIndex: indexPath.row)
        }
    }
    
    // MARK: - Private functions
    private func bindToViewModel() {
        viewModel?.didUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private  func applyAction() {
        viewModel?.applyFilters()
        dismiss(animated: true, completion: nil)
    }

    @objc private func clearAction() {
        viewModel?.clearFilters()
    }
}
