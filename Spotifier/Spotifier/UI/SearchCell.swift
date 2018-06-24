//
//  SearchCell.swift
//  Spotifier
//
//  Created by Drago on 6/19/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit
import Kingfisher

final class SearchCell: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        cleanup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cleanup()
    }

}

extension SearchCell {
    func populate(with item: SearchResult) {
        label.text = item.name
        
        if let url = item.imageURL {
            photoView.kf.setImage(with: url)
        }
    }
}

private extension SearchCell {
    func cleanup() {
        label.text = nil
        photoView.image = nil
    }
    
    func setup() {
        layer.cornerRadius = 4
    }
}





