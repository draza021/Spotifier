//
//  DataManager.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

final class DataManager {
    private var spotify = Spotify()
    
    private var searchResults: [String: [SearchResult]] = [:]
    
}



extension DataManager {
    func search(for term: String, type: Spotify.SearchType, callback: @escaping ([SearchResult], DataError?) -> Void) {
        
        callback(searchResults[term] ?? [], nil)
        
        let endpoint: Spotify.Endpoint = .search(term: term, type: type, market: nil, limit: nil, offset: nil)
        spotify.call(endpoint: endpoint) { (json, spotifyError) in
            
            if let spotifyError = spotifyError {
                callback([], .spotifyError(spotifyError))
                return
            }
            
            guard let json = json else {
                callback([], .noData)
                return
            }
            
            // convert JSON to Artist, Album, etc.
            
            // return back to UI
            callback([], nil)
            
        }
    }
}
