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
    
    var flattenedItems = [Post]()
    var collapsedCellIndices = [Int]()
    
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
    
    func togglePostOpenAtIndex(idx: Int) {
        if contains(collapsedCellIndices, idx) {
            openPostAtIndex(idx)
        } else {
            collapsePostAtIndex(idx)
        }
    }
    
    func collapsePostAtIndex(idx: Int) {
        let post = flattenedItems[idx]
        let tier = post.tier
        
        collapsedCellIndices.append(idx)
        
        for i in (idx+1)..<flattenedItems.count {
            let child = flattenedItems[i]
            
            if child.tier > tier {
                collapsedCellIndices.append(i)
            } else {
                break
            }
        }

        tableView.reloadData()
//        tableView.beginUpdates()
//        tableView.endUpdates()
    }
    
    func openPostAtIndex(idx: Int) {
        let post = flattenedItems[idx]
        let tier = post.tier
        
        for i in 0..<collapsedCellIndices.count {
            let cellIdx = collapsedCellIndices[i]
            
            if cellIdx >= idx {
                let child = flattenedItems[cellIdx]
                
                if child.tier > tier {
                    collapsedCellIndices.removeAtIndex(i)
                } else {
                    break
                }
            }
        }

        tableView.reloadData()
//        tableView.beginUpdates()
//        tableView.endUpdates()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return flattenedItems.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(CommentsCellIdentifier, forIndexPath: indexPath) as CommentCell
        
        if contains(collapsedCellIndices, indexPath.row) {
            cell.commentLabel.text = ""
        } else {
            configureCell(cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    func configureCell(cell: CommentCell, indexPath: NSIndexPath) {
        let post = flattenedItems[indexPath.row]
        cell.commentLabel.setMarkup(post.text)
        cell.setCommentTier(post.tier)
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        togglePostOpenAtIndex(indexPath.row)
    }
    
}
