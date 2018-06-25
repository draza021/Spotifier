//
//  SearchLayout.swift
//  Spotifier
//
//  Created by Drago on 6/21/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class SearchLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        commonInit()
    }
    
    func commonInit() {
        guard var availableWidth = collectionView?.bounds.width else { return }
    
        // defaults
        itemSize = CGSize(width: 150, height: 225)
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        scrollDirection = .vertical
        
        
        // customize for collectionView bounds.width
        let aspectRatio = itemSize.width / itemSize.height
        let columns = floor(availableWidth / itemSize.width)
        
        availableWidth -= (columns - 1) * minimumInteritemSpacing
        availableWidth -= (sectionInset.left + sectionInset.right)
        
        itemSize.width = availableWidth / columns
        //itemSize.height = itemSize.width * 1/aspectRatio
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let bounds = collectionView?.bounds else { return false }
        
        return bounds.width != newBounds.width
    }
    
}





