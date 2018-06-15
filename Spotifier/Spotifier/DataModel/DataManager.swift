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
        spotify.call(endpoint: endpoint) {
            fileData, spotifyError in
            
            if let spotifyError = spotifyError {
                callback([], .spotifyError(spotifyError))
                return
            }
            
            guard let fileData = fileData else {
                callback([], .noData)
                return
            }
            
            switch type {
            case .artist:
                let decoder = JSONDecoder()
                
                do {
                    let artistResponse = try decoder.decode(SpotifyArtistsResponse.self, from: fileData)
                    let artists: [SearchResult] = artistResponse.artists.items
                    callback(artists, nil)
                    
                } catch {
                    callback([], .genericError(error))
                }
                
            case .album, .playlist, .track:
                break
            }
            
            
            // return back to UI
            callback([], nil)
            
        }
    }
}
