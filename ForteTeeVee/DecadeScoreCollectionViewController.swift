//
//  MUSDecadeScoreCollectionViewController.swift
//  swift-forte2
//
//  Created by brendon mckinley on 2/07/2015.
//  Copyright (c) 2015 brendon mckinley. All rights reserved.
//

import UIKit

class DecadeScoreCollectionViewController: ScoreCollectionViewController {
    
    let kShowComposersSegueIdentifier = "ShowComposers"
    
    dynamic var decade: String?
    var composersSegmentIndex: Int?
    var composersIndexPath: NSIndexPath?
    var composer:String?
    
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
            if let _ = composer {
                return String(format: "%@ (%i items)", composer!, numberOfScoresInCollection!)
            }
            else if let _ = decade {
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
            if composer != nil {
                return dataController!.numberOfScoresInDecade(decade!, byComposer: composer!)
            }
            else {
                return dataController!.numberOfScoresInDecade(decade!)
            }
        }
        set {
            self.numberOfScoresInCollection = newValue
        }
    }
    
    override func scoreAtIndexPathInCollection(indexPath: NSIndexPath) -> Score {
        if composer == nil {
            return (dataController?.scoreAtIndex(indexPath, inDecade: decade!))!
        }
        else {
            return (dataController?.scoreAtIndex(indexPath, indDecade: decade!, byComposer: composer!))!
        }
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "decade" {
            composer = nil
            composersIndexPath = nil
            composersSegmentIndex = 0
            print("kvo! \(decade)", terminator: "\n")
            // brandingImage.hidden = true
            titleLabel.text = titleString
            //composerButtonItem.enables = true
            collectionView.reloadData()
            let firstItemPath = NSIndexPath(forItem: 0, inSection: 0)
            collectionView.scrollToItemAtIndexPath(firstItemPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: false)
            //indexView.hidden = false
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "decade")
    }
    
}
