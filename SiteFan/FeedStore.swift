//
//  FeedStore.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/10/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit
import Foundation

class FeedStore: NSObject, NSXMLParserDelegate {
    var items: [FeedItem] = []
    var item: FeedItem!
    
    var element: String = ""
    
    var titleBuffer: String = ""
    var linkBuffer: String = ""
    var pubDateBuffer: String = ""
    var guidBuffer: String = ""
    
    var completion: (() -> ())?
    
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ"
        return dateFormatter
        }()

    
    func fetch(url: NSURL, completion: (() -> ())?) {
        self.completion = completion
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if (error) {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertView(title: "Network Error", message: "Oh no! The Internet is broken.", delegate: nil, cancelButtonTitle: "Bummer")
                    alert.show()
                }
                return
            }
            
            let content = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("response: \(response)")
            println("content: \(content)")
            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.shouldResolveExternalEntities = false
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        if (elementName == nil) {
            return
        }
        
        element = elementName
        if element == "item" {
            
            titleBuffer = ""
            linkBuffer = ""
            pubDateBuffer = ""
            guidBuffer = ""
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        if element == "title" {
            titleBuffer = titleBuffer + string
        } else if element == "link" {
            linkBuffer = linkBuffer + string
        } else if element == "pubDate" {
            pubDateBuffer = pubDateBuffer + string
        } else if element == "guid" {
            guidBuffer = guidBuffer + string
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if elementName == "item" {
            let title = titleBuffer.componentsSeparatedByString("\n")[0]
            let link = linkBuffer.componentsSeparatedByString("\n")[0]
            let pubDate = dateFormatter.dateFromString(pubDateBuffer.componentsSeparatedByString("\n")[0])
            
            let guid = guidBuffer.componentsSeparatedByString("\n")[0]
            
            item = FeedItem(title: title, link: link, pubDate: pubDate, guid: guid)
            
            let predicate = NSPredicate(format: "guid like %@", argumentArray: [guid])
            let matches = (items as NSArray).filteredArrayUsingPredicate(predicate)
            
            if (matches.count == 0) {
                items.append(item)
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
        if let completion = completion? {
            completion()
        }
    }
}
