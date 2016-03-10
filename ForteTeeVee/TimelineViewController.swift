/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class TimelineViewController: UITableViewController {
    
    // MARK: - Properties
    var decadeScoreCollectionController: DecadeScoreCollectionViewController? = nil
    
    var dataController: DataController?
    var selectedDecade: String?
    
    private var lastPerformedSegueIdentifier: String?
    private let delayedSeguesOperationQueue = NSOperationQueue()
    private static let performSegueDelay: NSTimeInterval = 0.01
    
    var decades: [AnyObject]?
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.remembersLastFocusedIndexPath = true
        dataController = DataController.sharedController
        decades = dataController?.decadesInWhichMusicWasPublished()
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            decadeScoreCollectionController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DecadeScoreCollectionViewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (decades?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let decade = decades?[indexPath.row]
        if let _ = decade!.valueForKey("date") {
            cell.textLabel!.text = decade!.valueForKey("date") as! String
        } else {
            cell.textLabel!.text = "No date"
        }
        //cell.detailTextLabel!.text = "decade"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let menuSplitViewController = splitViewController as? MenuSplitViewController else { return }
        menuSplitViewController.updateFocusToDetailViewController()
    }
    
    override func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        // Check that the next focus view is a child of the table view.
        guard let nextFocusedView = context.nextFocusedView where nextFocusedView.isDescendantOfView(tableView) else { return }
        guard let indexPath = context.nextFocusedIndexPath else { return }
        print("we got here")
        
        // Cancel any previously queued segues.
        delayedSeguesOperationQueue.cancelAllOperations()
        
        // Create an `NSBlockOperation` to perform the detail segue after a delay.
        let performSegueOperation = NSBlockOperation()
        let segueIdentifier = "showDetail"
        
        performSegueOperation.addExecutionBlock { [weak self, unowned performSegueOperation] in
            // Pause the block so the segue isn't immediately performed.
            NSThread.sleepForTimeInterval(TimelineViewController.performSegueDelay)
            
            /*
             Check that the operation wasn't cancelled and that the segue identifier
             is different to the last performed segue identifier.
             */
            guard !performSegueOperation.cancelled else { return }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                // Perform the segue to show the detail view controller.
                print("pref seg")
                self?.performSegueWithIdentifier(segueIdentifier, sender: nextFocusedView)
                
                // Record the last performed segue identifier.
                self?.lastPerformedSegueIdentifier = segueIdentifier
                
                /*
                 Select the focused cell so that the table view visibly reflects
                 which detail view is being shown.
                 */
                self?.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            }
        }
        
        delayedSeguesOperationQueue.addOperation(performSegueOperation)
    }

    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prep for seg")
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let decade = decades?[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DecadeScoreCollectionViewController
                controller.decade = decade!.valueForKey("date") as! String
            }
        }
    }
    
}
