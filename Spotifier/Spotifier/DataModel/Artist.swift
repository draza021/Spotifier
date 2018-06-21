//
//  Artist.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

struct Followers: Codable {
    let total: Int
}

struct Artist: Codable {
    let name: String
    let id: String
    //    let apiURL: URL
    //
    var popularity: Int
    var genres: [String] = []
    var webURL: URL?
    //
    var images: [Image] = []
    
    private let followers: Followers
    var followersCount: Int { return followers.total }
}

struct SpotifyArtistsContainer: Codable {
    let items: [Artist]
}

struct SpotifyArtistsResponse: Codable {
    let artists: SpotifyArtistsContainer
}

extension Artist: SearchResult {
    var imageURL: URL? {
        return images.first?.url
    }
}
