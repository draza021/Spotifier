//
//  UIKit-Extensions.swift
//  Spotifier
//
//  Created by Drago on 6/19/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    static var storyboardName: String {
        return String(describing: self)
    }
}


