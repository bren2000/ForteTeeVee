//
//  MUSScoreViewController.swift
//  swift-forte2
//
//  Created by brendon mckinley on 18/07/2015.
//  Copyright © 2015 brendon mckinley. All rights reserved.
//

import UIKit
import Haneke

class ScoreViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private var pages: [Page]?
    var score: Score?
    
    private let scorePageViewControllerCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        pages = score!.valueForKey("orderedPages") as? [Page]
        let initialViewController = scorePageViewControllerForPage(0)
        setViewControllers([initialViewController], direction: .Forward, animated: true, completion: nil)
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = indexOfDataItemForViewController(viewController)
        if index > 0 {
            return scorePageViewControllerForPage(index - 1)
        }
        else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = indexOfDataItemForViewController(viewController)
        if index < pages!.count - 1 {
            return scorePageViewControllerForPage(index + 1)
        }
        else {
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages!.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first else { fatalError("Unable to get the page controller's current view controller.") }
        return indexOfDataItemForViewController(currentViewController)
    }

    
    // MARK: Convenience
    
    private func indexOfDataItemForViewController(viewController: UIViewController) -> Int {
        guard let viewController = viewController as? ScorePageViewController else { fatalError("Unexpected view controller type in page view controller.") }
        guard let viewControllerIndex = pages!.indexOf(viewController.page!) else { fatalError("View controller's data item not found.") }
        return viewControllerIndex
    }
    
    private func scorePageViewControllerForPage(pageIndex: Int) -> ScorePageViewController {
        let page = pages![pageIndex]
        if let cachedController = scorePageViewControllerCache.objectForKey(page.identifier) as? ScorePageViewController {
            // Return the cached view controller.
            return cachedController
        }
        else {
            // Instantiate and configure a `ScorePageViewController`.
            guard let controller = storyboard?.instantiateViewControllerWithIdentifier(ScorePageViewController.storyboardIdentifier) as? ScorePageViewController else { fatalError("Unable to instantiate a ScorePageViewController.") }
            controller.configureWithDataItem(page)
            // Cache the view controller so it can be reused.
            scorePageViewControllerCache.setObject(controller, forKey: page.identifier)
            // Return the newly created and cached view controller.
            return controller
        }
    }

}

