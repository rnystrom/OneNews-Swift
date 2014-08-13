//
//  HackerNewsServices.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

struct HackerNewsClient {
    
    private let OFFLINE_DEBUG = false
    
    func fetchFrontPage(callback: ([Post]?, NSError?) -> Void) {
        let handler: (JSONValue?, NSError?) -> Void = { json, error in
            if let err = error {
                callback(nil, err)
                return
            }
            
            var items = [Post]()
            
            if let jsonItems = json?.array {
                items = jsonItems.map { decodeHackerNews($0, 0).post }
            }
            
            callback(items, nil)
        }
        
        if OFFLINE_DEBUG {
            // test data
            let path = NSBundle.mainBundle().pathForResource("rss", ofType: "json")
            let data = NSData(contentsOfFile: path)
            let json = JSONValue(data)
            handler(json, nil)
        } else {
            // production
            fetchJSON("https://hn.algolia.com/rss.json", handler)
        }
    }
    
}
