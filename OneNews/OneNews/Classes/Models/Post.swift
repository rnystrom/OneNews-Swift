//
//  NewsItem.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

struct Post: Equatable {
    
    // values from the API
    let author: String
    let createdAt: NSDate
    let apiID: Int
    let points: Int = 0
    let title: String?
    let url: String?
    let text: String?
    
    // post/comment tree values
    let comments: [Post]
    let totalComments: Int
    let tier: Int
    
}

func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.apiID == rhs.apiID
}

enum PostResult {
    case Some(Post)
    case None
}

func decodeHackerNews(json: JSONValue, tier: Int) -> PostResult {
    var children = [Post]()
    var commentCount = 0
    
    if let childrenJSON = json["children"].array {
        
        // builds comment tree recursively
        for childJSON in childrenJSON {
            switch decodeHackerNews(childJSON, tier + 1) {
            case let .Some(post):
                children.append(post)
                commentCount += post.totalComments + 1
            default: ()
            }
        }
        
    }
    
    let author = json["author"]
    let createdAt = json["created_at_i"]
    let apiID = json["id"]
    let points = json["points"]
    let text = json["text"]
    let title = json["title"]
    let type = json["type"]
    let url = json["url"]
    
    // http://natashatherobot.com/swift-unwrap-multiple-optionals/
    // required properties
    // author: String
    // createdAt: NSDate
    // apiID: Int
    switch (author.string, createdAt.double, apiID.integer) {
    case let(.Some(author), .Some(createdAt), .Some(apiID)):
        let date = NSDate(timeIntervalSince1970: createdAt)
        let p = points.integer ?? 0 // points can be optional
        
        let post = Post(
            author: author,
            createdAt: date,
            apiID: apiID,
            points: p,
            title: title.string,
            url: url.string,
            text: text.string,
            comments: children,
            totalComments: commentCount,
            tier: tier
        )
        return .Some(post)
    default:
        return .None
    }
}
