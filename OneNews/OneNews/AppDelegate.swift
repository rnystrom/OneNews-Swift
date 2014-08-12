//
//  AppDelegate.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/8/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        let cacheSizeMemory = 4*1024*1024
        let cacheSizeDisk = 32*1024*1024
        let sharedCache = NSURLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "nsurlcache")
        NSURLCache.setSharedURLCache(sharedCache)
        
        return true
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        println("clearing shared cache")
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }

}

