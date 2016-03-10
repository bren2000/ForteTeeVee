//
//  NLAOpenArchiveController.swift
//  swift-forte2
//
//  Created by brendon mckinley on 6/07/2015.
//  Copyright (c) 2015 brendon mckinley. All rights reserved.
//

import Foundation
//import AFNetworking
import Alamofire

/**
A class to manage the interactions with the National Library's
Open Archive Interface.
*/
class NLAOpenArchiveController: NSObject, NSXMLParserDelegate {
    
    let dcElements: DCElements = DCElements()
    var queue: NSOperationQueue?
    var currentElement: String?
    var characters: String?
    var itemInformation = NLAItemInformation()
    
    typealias SuccessBlock = (itemInfo: NLAItemInformation) -> (Void)
    var successBlock: SuccessBlock?
    
    static let sharedInstance: NLAOpenArchiveController = NLAOpenArchiveController()
    
    /**
    Obtain a reference to the shared controller.
    */
    func sharedController() -> NLAOpenArchiveController {
        return NLAOpenArchiveController.sharedInstance
    }
    
    /**
    Request the details for the item with the given identifier. The success callback will
    be called with the resulting NLAItemInformation object or nil if there was an error
    retreiving the information.
    */
    func requestDetailsForItemWithIdentifier(itemIdentifier: String, success: SuccessBlock) {
        
        successBlock = success
        
        if queue == nil {
            queue = NSOperationQueue()
        }
        let urlString = "https://www.nla.gov.au/apps/oaicat/servlet/OAIHandler?verb=GetRecord&metadataPrefix=oai_dc&identifier=oai:nla.gov.au:" + itemIdentifier
        print(urlString)
        //var itemInfo = NLAItemInformation()
        Alamofire.request(.GET, urlString)
            .responseString { (response) in
                //self.itemInformation = itemInfo
                //let xmldata = (response.data! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let xmldata = response.data
                let XMLParser = NSXMLParser(data: xmldata!)
                XMLParser.delegate = self
                XMLParser.parse()
        }
        
        //queue!.addOperations([requestOperation as! AFHTTPRequestOperation], waitUntilFinished: true)
        //queue!.addOperations([operation], waitUntilFinished: true)
        
    }

    // MARK: - XML Parser Delegate Methods

    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        characters = String()
        switch elementName {
        case dcElements.kTitleKey, dcElements.kPublisherKey, dcElements.kDescriptionKey,
                dcElements.kDateKey, dcElements.kCreatorKey:
            currentElement = elementName
        default:
            currentElement = nil
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElement != nil {
            if let _ = characters {
                characters = string
            }
            else {
                characters = string
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case dcElements.kTitleKey:
            itemInformation.title = characters
        case dcElements.kPublisherKey:
            itemInformation.publisher = characters
        case dcElements.kDescriptionKey:
            itemInformation._description = characters
        case dcElements.kDateKey:
            itemInformation.date = characters
        case dcElements.kCreatorKey:
            itemInformation.creator = characters
        default:
            break
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        successBlock!(itemInfo: itemInformation)
        //dispatch_async(dispatch_get_main_queue()) { successBlock?.itemInfo }
    }
    
}
    
struct DCElements {
    let kTitleKey = "dc:title"
    let kCreatorKey = "dc:creator"
    let kDescriptionKey = "dc:description"
    let kPublisherKey = "dc:publisher"
    let kDateKey = "dc:date"
}

