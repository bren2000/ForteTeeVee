//
//  Score.swift
//  swift-forte2
//
//  Created by brendon mckinley on 13/07/2015.
//  Copyright (c) 2015 brendon mckinley. All rights reserved.
//

import Foundation
import CoreData

class Score: NSManagedObject {

    @NSManaged var creator: String
    @NSManaged var date: String
    @NSManaged var identifier: String
    @NSManaged var publisher: String
    @NSManaged var sortTitle: String
    @NSManaged var title: String
    @NSManaged var pages: NSSet
    
    var firstLetterOfTitle: String? {
        get {
            self.willAccessValueForKey("firstLetterOfTitle")
            let str = title.uppercaseString
            return str.substringWithRange(Range<String.Index>(start: str.startIndex, end: str.startIndex.advancedBy(1)))
        }
    }
    
    func thumbnailURL() -> NSURL? {
        return NSURL(string: String(format: "https://nla.gov.au/%@-t", identifier))
    }
    
    func coverURL() -> NSURL? {
        return NSURL(string: String(format: "https://nla.gov.au/%@-e", identifier))
    }
    
    func webURL() -> NSURL? {
        return NSURL(string: String(format: "https://nla.gov.au/%@", identifier))
    }
    
//    func cacheDirectory() -> String? {
//        let expandedTilde = true
//        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, expandedTilde)
//        let cachePath = paths[0]
//        let scorePath = cachePath.stringByAppendingPathComponent(identifier)
//        return scorePath
//    }
    

}
