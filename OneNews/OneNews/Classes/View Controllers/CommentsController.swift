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
    
    typealias PostTiers = (post: Post, tier: Int, renderedText: NSAttributedString?)

    var item: Post? {
        didSet {
            self.flattenAllItems()
        }
    }
    
    var flattenedItems: [PostTiers]?
    
    func flattenAllItems() {
        if let post = item {
            dispatch_background {
                let children = self.flattenChildren(post, tier: 0)
                
                dispatch_main {
                    self.flattenedItems = children
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func flattenChildren(post: Post, tier: Int) -> [PostTiers] {
        var html: NSAttributedString? = nil
        
        var posts = [(post, tier, html)] as [PostTiers]
        
        if let comments = post.comments {
            let deeper = tier + 1

            for comment in comments {
                let tuple = flattenChildren(comment, tier: deeper)
                posts += tuple
            }
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
        if let post = item {
            return post.totalComments
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
        
        if let html = flattenedItems?[idx].renderedText {
            cell.commentLabel.attributedText = html
        } else if let item = flattenedItems?[idx] {
            if let text = item.post.text {
                let html = renderedHTML(text)
                
                cell.commentLabel.attributedText = html
                
                flattenedItems?[idx] = (item.post, item.tier, html)
            }
        } else {
            cell.commentLabel.text = ""
        }
    }
    
}
