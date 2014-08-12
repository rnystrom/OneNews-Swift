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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commentLabel.preferredMaxLayoutWidth = CGRectGetWidth(commentLabel.frame)
        
//        super.layoutSubviews()
    }

}
