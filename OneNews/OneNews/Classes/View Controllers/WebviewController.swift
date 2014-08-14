//
//  WebviewController.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

class WebviewController: UIViewController, UIWebViewDelegate {
    
    // optional b/c VC is loaded from storyboard so we can't use custom init
    var item: Post?
    var activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlString = item?.url {
            let url = NSURL(string: urlString)
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
            
            title = url.host
        }
        
        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(toolbar.frame), 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if traitCollection.containsTraitsInCollection(UITraitCollection(userInterfaceIdiom: .Pad)) {
            navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        webView.reload()
    }
    
    // MARK: Custom Actions

    @IBAction func onBack(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func onForward(sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func onRefresh(sender: AnyObject) {
        webView.reload()
    }
    
    @IBAction func onShare(sender: AnyObject) {
        // TODO: share sheet
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView!) {
        if activity.isAnimating() {
            return
        }
        
        activity.startAnimating()
        
        // replaces "refresh" button setup in storyboard
        toolbar.items[toolbar.items.count-1] = UIBarButtonItem(customView: activity)
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        if webView.loading {
            return
        }
        
        activity.stopAnimating()
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("onRefresh:"))
        // replaces activity indicator setup in webViewDidStartLoad:
        toolbar.items[toolbar.items.count-1] = refresh
    }
    
}
