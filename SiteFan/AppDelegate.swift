//
//  AppDelegate.swift
//  SiteFan
//
//  Created by Wiley Wimberly on 8/10/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        
        let tabBarController = UITabBarController()
        
        let feedViewController = FeedViewController()
        feedViewController.title = "Feed"
        
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        feedNavigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "RSS"), tag: 0)
        
        let tweetsViewController = TweetsViewController()
        tweetsViewController.title = "Tweets"
        
        let tweetsNavigationController = UINavigationController(rootViewController: tweetsViewController)
        tweetsNavigationController.tabBarItem = UITabBarItem(title: "Tweets", image: UIImage(named: "Twitter"), tag: 1)
        
        tabBarController.viewControllers = [feedNavigationController, tweetsNavigationController]
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = tabBarController
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()

        return true
    }
}

