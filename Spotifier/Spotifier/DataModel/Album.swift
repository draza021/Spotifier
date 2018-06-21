//
//  Album.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

struct Album: Codable {
    let name: String
    let id: String
    
    var images: [Image] = []
}

//second level
struct SpotifyAlbumsContainer: Codable {
    let items: [Album]
}

// first level
struct SpotifyAlbumsResponse: Codable {
    let albums: SpotifyAlbumsContainer
}

extension Album: SearchResult {
    var imageURL: URL? {
        return images.first?.url
    }
}

