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
    
}



extension DataManager {
    func search(for term: String, type: Spotify.SearchType, callback: @escaping ([SearchResult], DataError?) -> Void) {
        
    }
}
