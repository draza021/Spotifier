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
    @IBOutlet private weak var searchBar: UIVisualEffectView!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var segmentedControll: UISegmentedControl!
    
    
    
    // MARK: - External Dependencies
    var dependencies: AppDependency?
    
    // MARK: - Local data model
    private var searchTerm: String? {
        didSet {
            if !isViewLoaded { return }
            search()
        }
    }
    
    private var searchType: Spotify.SearchType = .artist {
        didSet {
            if !isViewLoaded { return }
            search()
        }
    }
    
    private var results: [SearchResult] = [] {
        didSet {
            if !isViewLoaded { return }
            collectionView.reloadData()
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        searchField.delegate = self
        
        let cellNib = UINib(nibName: SearchCell.reuseIdentifier, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        
        setupNotificationHandlers()
        
        search()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        additionalSafeAreaInsets = UIEdgeInsetsMake(searchBar.bounds.height, 0, 0, 0)
        collectionView.contentInset.top = searchBar.bounds.height
    }
    
}

private extension SearchController {
    func setupNotificationHandlers() {
        let nc = NotificationCenter.default
        nc.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: .main) {
            [weak self] notification in
            self?.processKeyboardAppearance(notification)
        }
        
        nc.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: .main) {
            [weak self] notification in
            self?.processKeyboardDisappearance(notification)
        }
    }
    
    func processKeyboardAppearance(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        collectionView.contentInset.bottom = keyboardFrame.height
    }
    
    func processKeyboardDisappearance(_ notification: Notification) {
        collectionView.contentInset.bottom = 0
    }
    
    @IBAction func changeSearchType(_ sender: UISegmentedControl) {
        guard let st = Spotify.SearchType(index: sender.selectedSegmentIndex) else { return }
        searchType = st
    }
    
    @IBAction func changeSearchTypeWithCustomControl(_ sender: CustomSegmentedControl) {
        guard let st = Spotify.SearchType(index: sender.selectedSegmentIndex) else { return }
        searchType = st
    }
    
    @IBAction func changeSearchTerm(_ sender: UITextField) {
        searchTerm = sender.text
    }
    
    func search() {
        guard let dataManager = dependencies?.dataManager else {
            fatalError("Missing data manager")
        }
        
        guard let s = searchTerm, s.count > 0 else {
            results = []
            return
        }
        
        dataManager.search(for: s, type: searchType) {
            [weak self] arr, error in
            
            if arr.count == 0 { return }
            // TODO: -
            
            DispatchQueue.main.async {
                self?.results = arr
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

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}





