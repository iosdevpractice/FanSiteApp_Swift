//
//  WebViewController.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/13/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var webView: UIWebView!
    var url: NSURL?
    
    override func loadView() {
        webView = UIWebView(frame: UIScreen.mainScreen().bounds)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("url: \(url)")
        webView.loadRequest(NSURLRequest(URL: url))
    }
}
