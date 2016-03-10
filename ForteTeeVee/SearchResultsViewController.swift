//
//  SearchResultsViewController.swift
//  ForteTeeVee
//
//  Created by brendon mckinley on 9/03/2016.
//  Copyright © 2016 Brendon McKinley. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , UISearchResultsUpdating {
    
    static let storyboardIdentifier = "SearchResultsViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let ScoreCellIdentifier = "ScoreCell"
    let OpenScoreSegueIdentifier = "OpenScoreSegue"
    
    var dataController: DataController?
    var selectedScoreIndex: NSIndexPath?
    var selectedScore: Score?
    
    var decade: String? = "1890"
    
    var filterString = "" {
        didSet {
        print("did change")
        // Return if the filter string hasn't changed.
        guard filterString != oldValue else { return }
        collectionView!.reloadData()
        }
    }
    
    override func viewDidLoad() {
        dataController = DataController.sharedController
        collectionView!.delegate = self
        collectionView!.dataSource = self
        print("search view controller did load")
    }
    
    
    //MARK: Collection View Methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 50.0)
    }
    
    //MARK: - UICollectionView Data Source Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let number = dataController?.numberOfScoreForSearch(forPhrase: filterString) {
            return number
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ScoreCellIdentifier, forIndexPath: indexPath)  as? ScoreCell
        if let score = scoreAtIndexPathInCollection(indexPath) {
            cell?.score = score
            return cell!
        }
        cell?.score = Score()
        return cell!
    }
    
    //MARK: - UICollectionView Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedScore = scoreAtIndexPathInCollection(indexPath)
        selectedScoreIndex = indexPath
        self.performSegueWithIdentifier(self.OpenScoreSegueIdentifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let scoreController = segue.destinationViewController as? ScoreViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case OpenScoreSegueIdentifier:
                    scoreController.score = selectedScore!
                default:
                    break
                }
            }
        }
    }
    
    func scoreAtIndexPathInCollection(indexPath: NSIndexPath) -> Score? {
        print("score at index path in collection")
        return dataController?.scoreAtIndex(indexPath, searchPhrase: filterString)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
        print(filterString)
    }

    
}
