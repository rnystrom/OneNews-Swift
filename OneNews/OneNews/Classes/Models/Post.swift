//
//  NewsItem.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

struct Post {
    
    // values from the API
    let author: String = ""
    let createdAt: NSDate
    let hnID: Int = 0
    let points: Int = 0
    let title: String = ""
    let url: String?
    let text: String = ""
    
    // computed values
    var comments = Array<Post>()
    var totalComments = 0
    let tier = 0
    
    // determines if parent node
    var head = false
    
    // cache HTML -> NSAttributedString
    var renderedHTML: NSAttributedString = NSAttributedString(string: "")
    
    init(author: String?, createdAt: NSDate, hnID: Int?, points: Int?, title: String?, url: String?, text: String?, tier: Int = 0) {
        if let a = author {
            self.author = a
        }
        
        if let t = title {
            self.title = t
        }
        
        if let t = text {
            self.text = t
        }
        
        self.createdAt = createdAt
        self.hnID = hnID != nil ? hnID! : 0
        self.points = points != nil ? points! : 0
        self.url = url
        self.tier = tier
    }

}

typealias HackerNewsDecodeTuple = (post: Post, commentCount: Int)

// return tuple is for summing the comment count
func decodeHackerNews(json: JSONValue, tier: Int) -> HackerNewsDecodeTuple {
    let author = json["author"]
    let createdAt = json["created_at_i"]
    let hnID = json["id"]
    let points = json["points"]
    let text = json["text"]
    let title = json["title"]
    let type = json["type"]
    let url = json["url"]
    
    let date = createdAt ? NSDate(timeIntervalSince1970: createdAt.double!) : NSDate()
    
    var post = Post(
        author: author.string,
        createdAt: date,
        hnID: hnID.integer,
        points: points.integer,
        title: title.string,
        url: url.string,
        text: text.string,
        tier: tier
    )
    
    var commentCount = 0
    
    if let childJSON = json["children"].array {
        
        let children = childJSON.map { (var obj) -> Post in
            let tuple = decodeHackerNews(obj, tier + 1)
            commentCount += tuple.commentCount + 1
            return tuple.post
        }
        
        post.comments = children
        post.totalComments = commentCount
    }
    
    return (post, commentCount)
}
