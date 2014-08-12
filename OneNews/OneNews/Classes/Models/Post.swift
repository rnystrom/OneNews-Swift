//
//  NewsItem.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

class Post {
    
    let author: String?
    let createdAt: NSDate?
    let hnID: Int = 0
    let points: Int = 0
    let title: String?
    let url: String?
    
    var text: String?
    
    var comments: [Post]?
    var totalComments = 0
    
    var head = false
    
    init(author: String?, createdAt: NSDate, hnID: Int?, points: Int?, title: String?, url: String?, text: String?) {
        self.author = author
        self.createdAt = createdAt
        self.hnID = hnID != nil ? hnID! : 0
        self.points = points != nil ? points! : 0
        self.title = title
        self.url = url
        self.text = text
    }
    
    class func decodeHackerNews(json: JSONValue) -> (post: Post?, commentCount: Int)? {
        let author = json["author"]
        let createdAt = json["created_at_i"]
        let hnID = json["id"]
        let points = json["points"]
        let text = json["text"]
        let title = json["title"]
        let type = json["type"]
        let url = json["url"]
        
        // if a post doesn't have a created date, it shouldn't exist
        // also weird bugs w/ API
        if createdAt {
            var post = Post(
                author: author.string,
                createdAt: NSDate(timeIntervalSince1970: createdAt.double!),
                hnID: hnID.integer,
                points: points.integer,
                title: title.string,
                url: url.string,
                text: text.string
            )
            
            var commentCount = 0
            
            if let childJSON = json["children"].array {
                var children = [Post]()
                
                for obj in childJSON {
                    if let tuple = Post.decodeHackerNews(obj) {
                        if let post = tuple.post {
                            children.append(post)
                            
                            commentCount += tuple.commentCount + 1
                        }
                    }
                }
                
                post.comments = children
                post.totalComments = commentCount
            }
            
            return (post, commentCount)
        }
        
        return nil
    }
    
}