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
    
    let kScoreCellIdentifier = "ScoreCell"
    let kOpenScoreSegueIdentifier = "OpenScoreSegue"
    
    let kThumbnailHorizontalInset = 51.0
    let kThumbnailVerticalInset = 20.0
    let kThumbnailHeight = 150.0
    let kThumbnailWidth = 121.0
    
    let kThumbnailZoomDuration = 0.25
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        dataController = DataController.sharedController
    }
    
    
    override func viewDidAppear(animated: Bool) {
        // If there's a selectedScore and selectedCoverImageView
        // then scale the image down again
        if let _ = selectedScore {
            if let _ = selectedCoverImageView {
                let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(selectedScoreIndex!)!
                var convertedPoint = CGPointMake(cell.frame.origin.x, cell.frame.origin.y - collectionView.contentOffset.y)
                
                // Allow for the space that the thumbnail is inset from the cell
                convertedPoint = CGPointMake(convertedPoint.x + CGFloat(kThumbnailHorizontalInset), convertedPoint.y + CGFloat(kThumbnailVerticalInset))
                
                UIView.animateWithDuration(kThumbnailZoomDuration,
                                           animations: {
                                            self.selectedCoverImageView?.frame = CGRect(x: convertedPoint.x, y: convertedPoint.y, width: 121.0, height: 150.0)
                    },
                                           completion:  {(value: Bool) in
                                            self.selectedCoverImageView?.removeFromSuperview()
                                            self.selectedCoverImageView = nil
                                            self.selectedScore = nil
                                            self.selectedScoreIndex = nil
                    }
                )
            }
        }
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
    
    //MARK: - UICollectionView Data Source Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (numberOfScoresInCollection != nil) else {
            return 0
        }
        return numberOfScoresInCollection!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kScoreCellIdentifier, forIndexPath: indexPath)  as? ScoreCell
        let score = scoreAtIndexPathInCollection(indexPath)
        cell?.score = score
        //cell!.layer.shouldRasterize = true
        //cell!.layer.rasterizationScale = UIScreen.mainScreen().scale
        return cell!
    }
    
    //MARK: - UICollectionView Delegate Methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Disable touches until this transition is complete
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // Take note of the selected score
        selectedScore = scoreAtIndexPathInCollection(indexPath)
        selectedScoreIndex = indexPath
        
        // Get the selected cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        // Convert the origin of the selected cell to window coordinates
        let window = UIApplication.sharedApplication().keyWindow
        var convertedPoint = CGPointMake((cell?.frame.origin.x)!, (cell?.frame.origin.y)! - collectionView.contentOffset.y)
        
        // Allow for the space that the thumbnail is inset from the cell
        convertedPoint = CGPointMake(convertedPoint.x + CGFloat(kThumbnailHorizontalInset), convertedPoint.y + CGFloat(kThumbnailVerticalInset))
        
        // Create a new image view to scale to fill the view
        let thumbnailFrame = CGRectMake(CGFloat(convertedPoint.x), CGFloat(convertedPoint.y), CGFloat(kThumbnailWidth), CGFloat(kThumbnailHeight))
        var coverImageView: UIImageView?
        // TODO: network images
        coverImageView = UIImageView(frame: thumbnailFrame)
        coverImageView?.image = UIImage(named: "score_placeholder")
        view.addSubview(coverImageView!)
        selectedCoverImageView = coverImageView
        
        UIView.animateWithDuration(kThumbnailZoomDuration,
                                   animations: {
                                    let windowFrame = window!.frame
                                    coverImageView?.frame = windowFrame
            },
                                   completion:  {(value: Bool) in
                                    //coverImageView setPathToNetworkImage:[self.selectedScore.coverURL absoluteString]];
                                    self.performSegueWithIdentifier(self.kOpenScoreSegueIdentifier, sender: self)
            }
        )
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let scoreController = segue.destinationViewController as? MUSScoreViewController {
//            if let identifier = segue.identifier {
//                switch identifier {
//                case kOpenScoreSegueIdentifier:
//                    scoreController.score = selectedScore!
//                //scoreController.setInitialImage = selectedCoverImageView.image
//                default:
//                    break
//                }
//            }
//        }
//    }
    
}












