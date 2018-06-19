//
//  SearchController.swift
//  Spotifier
//
//  Created by Drago on 6/7/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

final class SearchController: UIViewController, NeedsDependency {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - External Dependencies
    var dependencies: AppDependency?
    
    // MARK: - Local data model
    private var searchTerm: String?
    private var searchType: Spotify.SearchType = .artist
    
    private var results: [SearchResult] = [] {
        didSet {
            // TODO: - Update UI
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cellNib = UINib(nibName: SearchCell.reuseIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchTerm = "taylor"
        search()
    }
}

private extension SearchController {
    
    func search() {
        guard let dataManager = dependencies?.dataManager else {
            fatalError("Missing data manager")
        }
        
        guard let s = searchTerm else { return }
        
        dataManager.search(for: s, type: searchType) {
            [weak self] arr, error in
            
            if arr.count == 0 { return }
            // TODO: -
            
            self?.results = arr
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension SearchController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
        
        // configure
        let res = results[indexPath.item]
        cell.populate(with: res)
        
        return cell
    }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError() }
        
        var itemSize = layout.itemSize
        let aspectRatio = itemSize.width / itemSize.height
        
        var availableWidth = collectionView.bounds.width
        let columns = floor(availableWidth / itemSize.width)
        
        availableWidth -= (columns - 1) * layout.minimumInteritemSpacing
        availableWidth -= (layout.sectionInset.left + layout.sectionInset.right)
        
        itemSize.width = availableWidth / columns
        itemSize.height = itemSize.width * 1/aspectRatio
        
        return itemSize
    }
}





