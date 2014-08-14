//
//  HackerNewsController.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

let HackerNewsCellIdentifier = "HackerNewsCellIdentifier"

class HackerNewsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("onRefresh:"), forControlEvents: .ValueChanged)
        
        onRefresh(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        tabBarController.title = "Hacker News"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        tableView.reloadData()
    }

    // MARK: Custom Actionss
    
    func onRefresh(sender: AnyObject!) {
        DataStore.sharedStore.fetchHackerNewsFrontPage {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func onCustomAccessoryTapped(sender: UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let item = itemForIndexPath(indexPath)
        
        let comments = storyboard.instantiateViewControllerWithIdentifier("Comments") as CommentsController
        comments.item = item
        
        showDetailViewController(comments, sender: self)
    }
    
    func itemForIndexPath(indexPath: NSIndexPath) -> Post {
        return DataStore.sharedStore.hackerNewsItems![indexPath.row]
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let items = DataStore.sharedStore.hackerNewsItems {
            return items.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(HackerNewsCellIdentifier, forIndexPath: indexPath) as HackerNewsCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: HackerNewsCell, indexPath: NSIndexPath) {
        let item = itemForIndexPath(indexPath)
        cell.titleLabel.text = item.title
        cell.authorLabel.text = item.author
        
        // ryan hacks code, and i dont care
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: Selector("onCustomAccessoryTapped:"), forControlEvents: .TouchUpInside)
        
        let points = item.points as Int?
        cell.pointsLabel.text = "\(points!)"
        
        cell.commentsLabel.text = "\(item.totalComments)"
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let item = itemForIndexPath(indexPath)
        
        let detail = storyboard.instantiateViewControllerWithIdentifier("Webview") as WebviewController
        detail.item = item
        
        showDetailViewController(detail, sender: self)
    }

}
