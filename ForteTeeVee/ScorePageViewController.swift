//
//  ScorePageViewController.swift
//  ForteTeeVee
//
//  Created by brendon mckinley on 7/03/2016.
//  Copyright © 2016 Brendon McKinley. All rights reserved.
//

import UIKit
import Haneke

class ScorePageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let storyboardIdentifier = "ScorePageViewController"
    
    var page: Page?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.hnk_setImageFromURL(page!.imageURL())
    }
    
    // MARK: Convenience
    
    func configureWithDataItem(page: Page) {
        self.page = page
    }
}
