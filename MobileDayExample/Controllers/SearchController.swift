//
//  SearchController.swift
//  MobileDayExample
//
//  Created by Chad Garrett on 2023/11/28.
//

import Foundation
import UIKit

class SearchController: UITableViewController {
    
    // MARK: - Properties
    
    var searchText: String = ""
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension SearchController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text ?? ""
    }
}
