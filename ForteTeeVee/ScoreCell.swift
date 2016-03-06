//
//  MUSScoreCell.swift
//  swift-forte2
//
//  Created by brendon mckinley on 5/07/2015.
//  Copyright (c) 2015 brendon mckinley. All rights reserved.
//

import UIKit
//import Haneke

class ScoreCell: UICollectionViewCell {

   
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet var titleLabel: UILabel!
    //@IBOutlet var noteImageView: UIImageView!

    
    dynamic var score: Score?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialise()
    }
    
    func initialise() {
        addObserver(self, forKeyPath: "score", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if (self.focused) {
            self.imageView.adjustsImageWhenAncestorFocused = true
        }
        else {
            self.imageView.adjustsImageWhenAncestorFocused = false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "score" {
            // Set a placeholder image
            imageView.image = UIImage(named: "thumbnail_placeholder")
            
            // Ppdate the details of the score
            //var reachability = Reachability.reachabilityForInternetConnection()
            // update the details of the score
            // TODO: Add reachability checks
            //noteImageView.hidden = true
            //imageView.hnk_setImageFromURL(score!.thumbnailURL()!)
            
            //let url = NSURL(string: score!.thumbnailURL()!)
            let data = NSData(contentsOfURL: score!.thumbnailURL()!)
            imageView.image = UIImage(data: data!)
            
            //titleLabel.text = score?.title
            
            
        }
    }
    
    override func prepareForReuse() {
        // TODO: complete with Nimbus
        // Cancel any pending network image request
        // imageView.prepareForReuse()
        //titleLabel.text = ""
    }
    
    deinit {
        removeObserver(self, forKeyPath: "score")
    }

}

