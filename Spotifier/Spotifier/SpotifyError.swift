//
//  SpotifyError.swift
//  Spotifier
//
//  Created by Drago on 6/12/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

enum SpotifyError: Error {
    case urlError(URLError)
    case invalidResponse
    case noData
}
