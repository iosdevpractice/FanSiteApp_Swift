//
//  TweetItem.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/14/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit

class TweetItem: NSObject {
   
    var text: String?
    var createdDate: NSDate?
    var url: NSURL?
    var tweetId: String?
    
    init(text: String?, createdDate: NSDate?, url: NSURL?, tweetId: String?) {
        self.text = text
        self.createdDate = createdDate
        self.url = url
        self.tweetId = tweetId
    }

}
