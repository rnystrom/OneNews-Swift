//
//  CommentsController.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/12/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

let CommentsCellIdentifier = "CommentsCellIdentifier"

class CommentsController: UITableViewController {

    var item: Post? {
        didSet {
            self.flattenAllItems()
        }
    }
    
    var flattenedItems: [Post]?
    
    func flattenAllItems() {
        if let post = item {
            dispatch_background {
                let children = self.flattenComments(post)
                
                dispatch_main {
                    self.flattenedItems = children
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func flattenComments(post: Post) -> [Post] {
        var posts = [post]

        for comment in post.comments {
            let comments = flattenComments(comment)
            posts += comments
        }
        
        return posts
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let posts = flattenedItems {
            return posts.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(CommentsCellIdentifier, forIndexPath: indexPath) as CommentCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: CommentCell, indexPath: NSIndexPath) {
        let idx = indexPath.row
        
        if var post = flattenedItems?[idx] {
            cell.commentLabel.setMarkup(post.text)
        }
    }
    
}
