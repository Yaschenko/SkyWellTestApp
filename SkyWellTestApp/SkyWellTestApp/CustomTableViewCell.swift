//
//  CustomTableViewCell.swift
//  SkyWellTestApp
//
//  Created by Yurii on 2/20/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var textHeight:NSLayoutConstraint!
    @IBOutlet weak var photoView:UIImageView!
    @IBOutlet weak var label:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
