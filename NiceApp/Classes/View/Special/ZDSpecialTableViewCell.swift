//
//  ZDSpecialTableViewCell.swift
//  NiceApp
//
//  Created by 边振东 on 9/6/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDSpecialTableViewCell: UITableViewCell {
    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorCareer: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDescription: UILabel!
    @IBOutlet weak var browse: UILabel!
    @IBOutlet weak var flower: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        authorAvatar.layer.cornerRadius = 15
        authorAvatar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
