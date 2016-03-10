//
//  MUSScoreCollectionViewController.swift
//  swift-forte2
//
//  Created by brendon mckinley on 18/07/2015.
//  Copyright © 2015 brendon mckinley. All rights reserved.
//

import UIKit

/**
 A view controller that manages a collection of scores.
 This is the common superclass for both the MUSFavouriteScoreCollectionViewController
 (which manages a collection of favourite scores) and the
 MUSDecadeScoreCollectionViewController (which manages a collection of scores published
 in a given decade).
 */
@IBDesignable
class ScoreCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var collectionView: UICollectionView!
    
    
    var dataController: DataController?
    var selectedScoreIndex: NSIndexPath?
    var selectedScore: Score?
    
    var selectedCoverImageView: UIImageView?
    
    /**
     The title that should be displayed in the toolbar. The default
     implementation returns an empty string. Subclasses should override
     this method to display a specific title.
     */
    var titleString: String?
    
    /**
     The number of scores in the collection. The default implementation
     returns 0. Subclasses should override this method to return a positive
     integer.
     */
    var numberOfScoresInCollection: Int?
    
    let ScoreCellIdentifier = "ScoreCell"
    let OpenScoreSegueIdentifier = "OpenScoreSegue"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        dataController = DataController.sharedController
    }
    
    //MARK: - Default Implementations to be Overridden
    
    /**
     The Score at the given index path in the collection. The default
     implementation returns nil. Subclasses should override this method
     to return an actual score.
     */
    func scoreAtIndexPathInCollection(indexPath: NSIndexPath) -> Score {
        return Score()
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
        guard (numberOfScoresInCollection != nil) else {
            return 0
        }
        return numberOfScoresInCollection!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ScoreCellIdentifier, forIndexPath: indexPath)  as? ScoreCell
        let score = scoreAtIndexPathInCollection(indexPath)
        cell?.score = score
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
                    print(selectedScore!.identifier)
                //scoreController.setInitialImage = selectedCoverImageView.image
                default:
                    break
                }
            }
        }
    }
    
}












