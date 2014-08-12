//
//  HackerNewsCell.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/10/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

class HackerNewsCell: UITableViewCell {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = contentView.frame.size.width - titleLabelLeading.constant - titleLabelTrailing.constant
        
        titleLabel.preferredMaxLayoutWidth = width
        authorLabel.preferredMaxLayoutWidth = width
    }
    
}
