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
    
    typealias PostTiers = (post: Post, tier: Int)

    var item: Post? {
        didSet {
            flattenAllItems()
        }
    }
    
    var flattenedItems: [PostTiers]?
    
    func flattenAllItems() {
        if item == nil {
            return
        }
        
        let post = item!
        flattenedItems = flattenChildren(post, tier: 0)
    }
    
    func flattenChildren(post: Post, tier: Int) -> [PostTiers] {
        var posts = [(post, tier)] as [PostTiers]
        
        if let comments = post.comments {
            let deeper = tier + 1

            for comment in comments {
                let tuple = flattenChildren(comment, tier: deeper)
                posts += tuple
            }
        }
        
        return posts
    }
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(CommentsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    // https://github.com/thecodepath/ios_guides/wiki/Generating-NSAttributedString-from-HTML
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        if let item = flattenedItems?[indexPath.row] {
            if let text = item.post.text {
                let styledText = "<span style=\"font-family: Helvetica Neue; font-size: 17px\">\(text)</span>"
                
                let data = styledText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                
                let options = [
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                ]
                
                let html = NSMutableAttributedString(data: data, options: options, documentAttributes: nil, error: nil)
//                html.addAttribute(NSFontAttributeName, value: cell.textLabel.font, range: NSMakeRange(0, html.length))
                
                cell.textLabel.attributedText = html
            }
        }
    }
    
}
