//
//  FeedViewController.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/10/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {

    let store = FeedStore()
    
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
        }()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        store.fetch(NSURL(string: "http://www.iosdevpractice.com/feed.xml")) {
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
        return store.items.count
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        
        let item = store.items[indexPath.row]
        cell!.textLabel.text = item.title
        
        cell!.detailTextLabel.text = dateFormatter.stringFromDate(item.pubDate)
        cell!.accessoryType = .DisclosureIndicator
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let item = store.items[indexPath.row]
        let url = NSURL(string: item.link)
        
        let webViewController = WebViewController()
        webViewController.url = url
        navigationController.pushViewController(webViewController, animated: true)
    }
}
