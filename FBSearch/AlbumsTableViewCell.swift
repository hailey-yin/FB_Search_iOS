//
//  AlbumsTableViewCell.swift
//  FBSearch
//
//  Created by Hailey Yin on 4/23/17.
//  Copyright © 2017 Hailey Yin. All rights reserved.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var showsDetails=false {
        didSet {
            if showsDetails == true {
                secondViewHeight.priority = 250
            } else {
                secondViewHeight.priority = 999
            }
        }
    }

}
