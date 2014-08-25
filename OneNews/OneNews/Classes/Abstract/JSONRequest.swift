//
//  JSONRequest.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

typealias FetchJSONCallback = (JSONValue?, NSError?) -> Void

func fetchJSON(url: String, callback: FetchJSONCallback) {
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