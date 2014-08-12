//
//  DataStore.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

class DataStore {
    class var sharedStore : DataStore {
        struct Static { static let instance = DataStore() }
        return Static.instance
    }
    
    let hackerNewsClient = HackerNewsClient()
    
    var hackerNewsItems: [Post]?
    var designerNewsItems: [Post]?
    
    func fetchHackerNewsFrontPage(callback: () -> Void) {
        hackerNewsClient.fetchFrontPage { items, error in
            self.hackerNewsItems = items
            
            dispatch_main {
                callback()
            }
        }
    }
}