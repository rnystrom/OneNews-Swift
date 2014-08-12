//
//  GCD.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/9/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import Foundation

typealias BlankClosure = () -> ()

func dispatch_main(block: BlankClosure) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func dispatch_background(block: BlankClosure) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block)
}