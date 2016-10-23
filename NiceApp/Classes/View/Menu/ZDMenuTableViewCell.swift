//
//  ZDMenuTableViewCell.swift
//  NiceApp
//
//  Created by 边振东 on 8/7/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dotView: UIImageView!

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
