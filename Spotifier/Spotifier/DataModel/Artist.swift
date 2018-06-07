//
//  Artist.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class Artist {
    
    var albums: [Album] = []
}



extension Artist: SearchResult {
    
    var id: String {
        return ""
    }
    
    var name: String {
        return ""
    }
    
    var image: UIImage? {
        return nil
    }
    
    
}
