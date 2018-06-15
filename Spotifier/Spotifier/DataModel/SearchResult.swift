//
//  SearchResult.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

protocol SearchResult {
    var id: String { get }
    var name: String { get }
    var imageURL: URL? { get }
}
