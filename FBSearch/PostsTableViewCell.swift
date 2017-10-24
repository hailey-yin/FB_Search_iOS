//
//  PostsTableViewCell.swift
//  FBSearch
//
//  Created by Hailey Yin on 4/24/17.
//  Copyright © 2017 Hailey Yin. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet weak var time: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
