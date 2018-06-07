//
//  SearchController.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class SearchController: UIViewController, NeedsDependency {
    
    // MARK: - External Dependencies
    var dependencies: AppDependency?
    
    // MARK: - Local data model
    private var searchTerm: String?
    private var searchType: Spotify.SearchType = .artist
    
    private var results: [SearchResult] = [] {
        didSet {
            // TODO: - Update UI
        }
    }
}

private extension SearchController {
    
    func search() {
        guard let dataManager = dependencies?.dataManager else {
            fatalError("Missing data manager")
        }
        
        guard let s = searchTerm else { return }
        
        dataManager.search(for: s, type: searchType) {
            [weak self] arr, error in
            
            // TODO: -
            
            self?.results = arr
            
        }
        
    }
}
