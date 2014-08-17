//
//  TweetsStore.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/14/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit
import Accounts
import Social

// https://dev.twitter.com/docs/ios/making-api-requests-slrequest

class TweetsStore: NSObject {
   
    let accountStore = ACAccountStore()
    var tweets: [TweetItem] = []
    
    var completion: (() -> ())?
    
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss ZZ yyyy"
        return dateFormatter
        }()
    
    func userHasAccessToTwitter() -> Bool {
        return SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
    }
    
    func fetchTimelineForUser(username: String, completion: (() -> ())?) {
        self.completion = completion
        
        if !userHasAccessToTwitter() {
            println("no twitter access")
            return
        }
        
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil) {
            granted, error in
            
            if !granted {
                println(error.localizedDescription)
                return
            }
            
            let twitterAccounts = self.accountStore.accountsWithAccountType(twitterAccountType)
            
            let url = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
            let params = [
                "screen_name": username,
                "include_rts": "1",
                "trim_user": "1",
                "count": "20"
            ]
            
            let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: params)
            
            request.account = twitterAccounts[0] as ACAccount
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            request.performRequestWithHandler() {
                responseData, urlResponse, error in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alert = UIAlertView(title: "Network Error", message: "Oh no! The Internet is broken.", delegate: nil, cancelButtonTitle: "Bummer")
                        alert.show()
                    }
                    return
                }

                if !responseData {
                    println("no response data, status code: \(urlResponse.statusCode)")
                    return
                }
                
                if urlResponse.statusCode >= 200 && urlResponse.statusCode < 300 {
                    var jsonError: NSError?
                    let timeLineData: NSArray! = NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments, error: &jsonError) as NSArray
                    if timeLineData == nil {
                        println("JSON error: \(jsonError?.localizedDescription)")
                    } else {
                        println("timeLineData: \(timeLineData)")
                        for entry in timeLineData {
                            
                            let text = ((entry["text"] as NSString).componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as NSArray).componentsJoinedByString(" ") as String
                            let created = self.dateFormatter.dateFromString(entry["created_at"] as String)
                            let id = entry["id_str"] as String
                            let url_string = "https://twitter.com/\(username)/status/\(id)"
                            let url = NSURL(string: url_string)
                            let tweet = TweetItem(text: text, createdDate: created, url: url, tweetId: id)
                            
                            self.tweets.append(tweet)
                        }
                        if let completion = self.completion? {
                            completion()
                        }
                    }
                }
            }
        }
    }
}
