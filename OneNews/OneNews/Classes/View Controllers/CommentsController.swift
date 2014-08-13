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
                let children = self.flattenChildren(post)
                
                dispatch_main {
                    self.flattenedItems = children
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func flattenChildren(post: Post) -> [Post] {
        var html: NSAttributedString? = nil
        
        var posts = [post]

        for comment in post.comments {
            let comments = flattenChildren(comment)
            posts += comments
        }
        
        return posts
    }
    
    // https://github.com/thecodepath/ios_guides/wiki/Generating-NSAttributedString-from-HTML
    func renderedHTML(text: String) -> NSAttributedString {
        let styledText = "<span style=\"font-family: Helvetica Neue; font-size: 17px\">\(text)</span>"
        
        let data = styledText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let options = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        let html = NSAttributedString(data: data, options: options, documentAttributes: nil, error: nil)
        
        return html
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
            if !post.text.isEmpty && post.renderedHTML.length == 0 {
                post.renderedHTML = renderedHTML(post.text)
                
                // posts are structs and passed by value, have to reassign
                flattenedItems?[idx] = post
            }
            
            cell.commentLabel.attributedText = post.renderedHTML
        }
    }
    
}
