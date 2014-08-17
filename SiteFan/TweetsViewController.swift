//
//  TweetsViewController.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/10/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit

class TweetsViewController: UITableViewController {

    let store = TweetsStore()
    
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchTimelineForUser("@iosdevpractice") {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {

        return store.tweets.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        
        let item = store.tweets[indexPath.row]
        cell!.textLabel.text = item.text
        cell!.accessoryType = .DisclosureIndicator
        cell!.textLabel.lineBreakMode = .ByWordWrapping
        cell!.textLabel.numberOfLines = 0
        cell!.textLabel.sizeToFit()
        cell!.detailTextLabel.text = dateFormatter.stringFromDate(item.createdDate)
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let item = store.tweets[indexPath.row]
        if (canOpenTwitter()) {
            let twitterUrlString = "twitter://status?id=\(item.tweetId!)"
            let url = NSURL(string: twitterUrlString)
            println("url: \(url)")
            UIApplication.sharedApplication().openURL(url)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        } else {
            let webViewController = WebViewController()
            webViewController.url = item.url
            navigationController.pushViewController(webViewController, animated: true)
        }
    }


    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        let item = store.tweets[indexPath.row]
        let text = item.text as NSString?
        let font = UIFont.systemFontOfSize(17.0)
        let textSize = CGSize(width: 280, height: CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
   
        let size = text!.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSParagraphStyleAttributeName: paragraphStyle.copy(), NSFontAttributeName: font], context: nil).size
        
        let padding = CGFloat(40.0)
        let height = max(CGFloat(ceil(size.height)) + padding, 44.0)
        println("row: \(indexPath.row) height: \(height)")
        return height
    }
    
    // MARK: - helpers
    
    func canOpenTwitter() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "twitter://"))
    }
}

