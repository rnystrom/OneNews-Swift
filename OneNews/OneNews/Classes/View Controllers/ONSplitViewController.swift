//
//  ONSplitViewController.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/8/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

// http://coding.tabasoft.it/ios/the-new-uisplitviewcontroller/
class ONSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        // defaults to .Automatic
        if traitCollection.containsTraitsInCollection(UITraitCollection(userInterfaceIdiom: .Pad)) {
            preferredDisplayMode = .AllVisible
        }
    }
    
    override func showDetailViewController(vc: UIViewController!, sender: AnyObject!) {
        if traitCollection.containsTraitsInCollection(UITraitCollection(userInterfaceIdiom: .Pad)) {
            super.showDetailViewController(UINavigationController(rootViewController: vc), sender: sender)
        } else {
            super.showDetailViewController(vc, sender: sender)
        }
    }
    
    // lets the iphone init w/ the master view, not detail
    func splitViewController(splitViewController: UISplitViewController!, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }

}
