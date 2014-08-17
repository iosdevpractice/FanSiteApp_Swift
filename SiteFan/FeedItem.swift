//
//  FeedItem.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/12/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit

class FeedItem: NSObject {
    
    var title: String?
    var itemDescription: String?
    var link: String?
    var pubDate: NSDate?
    var guid: String?
    
    init(title: String?, link: String?, pubDate: NSDate?, guid: String?) {
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.guid = guid
    }
}
