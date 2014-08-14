//
//  CommentCell.swift
//  OneNews
//
//  Created by Ryan Nystrom on 8/12/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentLeadingConstraint: NSLayoutConstraint!
    
    let commentTierIndent = CGFloat(10)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setCommentTier(0)
    }
    
    func setCommentTier(tier: Int) {
        // tiers start at 0
        let modTier = 2*tier + 1
        commentLeadingConstraint.constant = commentTierIndent * CGFloat(modTier)
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commentLabel.preferredMaxLayoutWidth = CGRectGetWidth(commentLabel.frame)
    }

}
