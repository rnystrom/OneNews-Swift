//
//  JSONRequest.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

func fetchJSON(url: String, callback: (JSONValue?, NSError?) -> Void) {
    let request = NSURLRequest(URL: NSURL(string: url))
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
        if let err = error {
            callback(nil, err)
            return
        }
        
        let json = JSONValue(data)
        callback(json, nil)
    }
    task.resume()
}