//
//  DataError.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import Foundation

enum DataError: Error {
    case spotifyError(SpotifyError)
    case noData
    
    case genericError(Swift.Error)
}
