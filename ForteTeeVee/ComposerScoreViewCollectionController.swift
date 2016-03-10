//
//  MUSDecadeScoreCollectionViewController.swift
//  swift-forte2
//
//  Created by brendon mckinley on 2/07/2015.
//  Copyright (c) 2015 brendon mckinley. All rights reserved.
//

import UIKit

class ComposerScoreViewCollectionController: ScoreCollectionViewController {
    
    dynamic var composer: String?

    @IBOutlet weak var collectionViews: UICollectionView!
// MARK - Overridden Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViews!.delegate = self
        collectionViews!.dataSource = self
        //indexView.delegate = self
        //titleLabel.text = ""
        super.viewDidLoad()
    }
    
    override var numberOfScoresInCollection: Int? {
        get {
            guard let _ = composer else {
                return 0
            }
            print("no of s in coll = \(dataController?.numberOfScoresInDecade("", byComposer: composer!))")
            return dataController?.numberOfScoresInDecade("", byComposer: composer!)
        }
        set {
            self.numberOfScoresInCollection = newValue
        }
    }
    
    override func scoreAtIndexPathInCollection(indexPath: NSIndexPath) -> Score {
        return (dataController?.scoreAtIndex(indexPath, indDecade: "", byComposer: composer!))!
    }
    
}
