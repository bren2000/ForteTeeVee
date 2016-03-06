//
//  Page.swift
//  swift-forte2
//
//  Created by brendon mckinley on 13/07/2015.
//  Copyright (c) 2015 brendon mckinley. All rights reserved.
//

import Foundation
import CoreData

class Page: NSManagedObject {

    @NSManaged var identifier: String
    @NSManaged var number: NSNumber
    @NSManaged var score: Score
    
    func imageURL() -> NSURL {
        return NSURL(string: String(format: "https://nla.gov.au/%@-e", identifier))!
    }
    
    func thumbnailURL() -> NSURL {
        return NSURL(string: String(format: "https://nla.gov.au/%@-t", identifier))!
    }
    
//    func cachedImagePath() -> String{
//        return (score.cacheDirectory()?.stringByAppendingPathComponent(identifier).stringByAppendingPathExtension("jpg"))!
//    }
//    
//    func cachedThumbnailImagePath() -> String{
//        return (score.cacheDirectory()?.stringByAppendingPathComponent(identifier).stringByAppendingString("-t").stringByAppendingPathExtension("jpg"))!
//    }

}
