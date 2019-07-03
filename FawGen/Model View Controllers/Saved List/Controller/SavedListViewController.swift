//
//  SavedListViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 02/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SavedListViewController: UITableViewController {
    
    // MARK: - Properties
    private let cellIdentifier = "SavedListCell"
    var savedList = [FakeWord]()
    var filteredList = [FakeWord]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        savedList = DefaultDB.getSavedList().sorted{ $0.created > $1.created }
        navigationItem.title = "Saved List"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewWillAppear")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredList.count
        }
        return savedList.count
    }

    
    /// Setups SearchController
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search!"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Returns a bool if we are currently filtering
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }


}


extension SavedListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SavedListCell
        let fakeWord: FakeWord
        if isFiltering() {
            fakeWord = filteredList[indexPath.row]
        } else {
            fakeWord = savedList[indexPath.row]
        }
        cell.fakeword = fakeWord
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if isFiltering() {
                filteredList.remove(at: indexPath.row).removeFromList()
            } else {
                savedList.remove(at: indexPath.row).removeFromList()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            //fakeWord.removeFromList()
        }
    }
    
    
    
}




extension SavedListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension SavedListViewController {
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredList = savedList.filter {$0.name.lowercased().contains(searchText.lowercased()) }.sorted{ $0.created > $1.created }
        tableView.reloadData()
    }
}
