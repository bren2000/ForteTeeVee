//
//  MUSScoreViewController.swift
//  swift-forte2
//
//  Created by brendon mckinley on 18/07/2015.
//  Copyright © 2015 brendon mckinley. All rights reserved.
//

import UIKit
import Haneke

class ScoreViewController: UIViewController, UIScrollViewDelegate {
    
    
    var delegate: MUSScoreViewControllerDelegate?
    var initialImage: UIImage?
    var initialPageNumber: Int?
    
    var imageDownloadQueue: NSOperationQueue?
    var coverImage: UIImage?
    var shareButtonRect: CGRect?
    var dataController: DataController?
    dynamic var itemInformation: NLAItemInformation?
    
    var score: Score?
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var pages: [Page] = []
    var pageCount: Int?
    
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var scorePageScrollView: UIScrollView!
    @IBOutlet weak var additionalInformationView: UIView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialise()
    }
    
    func initialise() {
        initialPageNumber = -1
        itemInformation = NLAItemInformation()
        itemInformation?.creator = "fish monger"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController = DataController.sharedController
        imageDownloadQueue = NSOperationQueue()
        
        addObserver(self, forKeyPath: "itemInformation", options: NSKeyValueObservingOptions.New, context: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        scorePageScrollView.addGestureRecognizer(tapRecognizer)
        scorePageScrollView.frame = view.bounds
        //scorePageScrollView.dataSource = self
        scorePageScrollView.delegate = self
        //scorePageScrollView.reloadData()
        
        titleLabel.text = score?.title
        descriptionLabel.text = nil
        creatorLabel.text = nil
        
        //print(score?.valueForKey("orderedPages")?.count, appendNewline: true)
        
        // Request the additional information
        let sharedController = NLAOpenArchiveController.sharedInstance.requestDetailsForItemWithIdentifier(score!.identifier) {
            (itemInfo: NLAItemInformation) -> Void in
            self.itemInformation = itemInfo
        }
        
        pages = score?.valueForKey("orderedPages") as! [Page]
        
        pageCount = numberOfPagesInPagingScrollView()
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount!
        
        for _ in 0..<pageCount! {
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scorePageScrollView.frame.size
        scorePageScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageCount!), pagesScrollViewSize.height)
        
        loadVisiblePages()
        
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= pages.count {
            // If it's outside the range of what you have to display, then do nothing
            print("gggo", separator: "", terminator: "\n")
            return
        }
        if let _ = pageViews[page] {
            print("yo", separator: "", terminator: "\n")
            // Do nothing. The view is already loaded.
        } else {
            var frame = scorePageScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView()
            
            newPageView.frame = frame
            newPageView.hnk_setImageFromURL(pages[page].imageURL())
            
            //let newPageView = UIImageView(image: pages[page].imageURL())
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scorePageScrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scorePageScrollView.frame.size.width
        let page = Int(floor((scorePageScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        print("\(page)", separator: "", terminator: "\n")
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    
    func purgePage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    override func viewWillAppear(animated: Bool) {
        //setSelectedPage()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    // MARK: UIScrollView methods
    
    func numberOfPagesInPagingScrollView() -> Int {
        let count = score?.valueForKey("orderedPages")?.count
        print(score?.valueForKey("webURL"))
        let s = score?.valueForKey("orderedPages") as! [Page]
        print(s[2].imageURL(), separator: "", terminator: "\n")
        //        print("\(s)", separator: "", terminator: "\n")
        //        for pg in score?.valueForKey("orderedPages") as! [Page] {
        //            print("\(pg.imageURL())", terminator: "\n")
        //        }
        return count!
    }
    
    // MARK: - UI Actions
    
    @IBAction func dismiss(sender: AnyObject) {
        // TODO: incomplete
        presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath! == "itemInformation" {
            // TODO: add spinny check and stop
            creatorLabel.text = itemInformation?.creator
            descriptionLabel.text = itemInformation?._description
            publisherLabel.text = itemInformation?.publisher
            dateLabel.text = itemInformation?.date
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "itemInformation")
    }
    
}

protocol MUSScoreViewControllerDelegate {
    func scoreViewController(controller: ScoreViewController, didDismissScore score: Score, atPageNumber pageNumber: Int)
}
