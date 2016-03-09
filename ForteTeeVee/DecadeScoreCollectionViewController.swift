//
//  MUSDecadeScoreCollectionViewController.swift
//  swift-forte2
//
//  Created by brendon mckinley on 2/07/2015.
//  Copyright (c) 2015 brendon mckinley. All rights reserved.
//

import UIKit

class DecadeScoreCollectionViewController: ScoreCollectionViewController, UISearchResultsUpdating {
    
    
    static let storyboardIdentifier = "DecadeScoreCollectionViewController"
    
    dynamic var decade: String?
    
    var filterString = "" {
        didSet {
        // Return if the filter string hasn't changed.
        guard filterString != oldValue else { return }
        
        // Apply the filter or show all items if the filter string is empty.
        if filterString.isEmpty {
            //filteredDataItems = allDataItems
        }
        else {
            //filteredDataItems = allDataItems.filter { $0.title.localizedStandardContainsString(filterString) }
            //return (dataController?.scoreAtIndex(indexPath, inDecade: decade!))!
        }
        
        // Reload the collection view to reflect the changes.
        collectionView?.reloadData()
        }
    }
    
    // MARK - Overridden Methods
    
    
    override func viewDidLoad() {
        addObserver(self, forKeyPath: "decade", options: NSKeyValueObservingOptions.New, context: nil)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        //indexView.delegate = self
        //titleLabel.text = ""
        super.viewDidLoad()
    }
    
    override var titleString: String? {
        get {
            if let _ = decade {
                let endOfDecade = String(format: "%i", Int(decade!)!)
                let count = dataController?.numberOfScoresInDecade(decade!)
                let title = String(format: "%@ - %@ (%i items)", decade!, endOfDecade, count!)
                return title
            }
            else {
                return ""
            }
        }
        set {
            self.titleString = newValue
        }
    }
    
    override var numberOfScoresInCollection: Int? {
        get {
            guard let _ = decade else {
                return 0
            }
            return dataController!.numberOfScoresInDecade(decade!)
        }
        set {
            self.numberOfScoresInCollection = newValue
        }
    }
    
    override func scoreAtIndexPathInCollection(indexPath: NSIndexPath) -> Score {
        return (dataController?.scoreAtIndex(indexPath, inDecade: decade!))!
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "decade" {
            titleLabel.text = titleString
            collectionView.reloadData()
            let firstItemPath = NSIndexPath(forItem: 0, inSection: 0)
            collectionView.scrollToItemAtIndexPath(firstItemPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: false)
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "decade")
    }
    
}
