//
//  SearchController.swift
//  ForteTeeVee
//
//  Created by Brendon McKinley on 9/03/2016.
//  Copyright © 2016 Brendon McKinley. All rights reserved.
//

import UIKit

class SearchResultsViewController: UICollectionViewController, UISearchResultsUpdating {
    // MARK: Properties
    
    static let storyboardIdentifier = "SearchResultsViewController"
    
    private let cellComposer = DataItemCellComposer()
    
    private let allDataItems = DataItem.sampleItems
    
    private var filteredDataItems = DataItem.sampleItems
    
    var dataController: DataController?
    
    var filterString = "" {
        didSet {
        // Return if the filter string hasn't changed.
        guard filterString != oldValue else { return }
        
        // Apply the filter or show all items if the filter string is empty.
        if filterString.isEmpty {
            filteredDataItems = allDataItems
        }
        else {
            filteredDataItems = allDataItems.filter { $0.title.localizedStandardContainsString(filterString) }
        }
        
        // Reload the collection view to reflect the changes.
        collectionView?.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDataItems.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Dequeue a cell from the collection view.
        return collectionView.dequeueReusableCellWithReuseIdentifier(DataItemCollectionViewCell.reuseIdentifier, forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? DataItemCollectionViewCell else { fatalError("Expected to display a `DataItemCollectionViewCell`.") }
        let item = filteredDataItems[indexPath.row]
        
        // Configure the cell.
        cellComposer.composeCell(cell, withDataItem: item)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
    }
}