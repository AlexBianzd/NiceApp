//
//  ZDForumTableViewCell.swift
//  NiceApp
//
//  Created by 边振东 on 9/6/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDForumTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerView: UIView!
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
    self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    self.clipsToBounds = true
    containerView.layer.cornerRadius = 3
    authorAvatar.layer.cornerRadius = 15
    authorAvatar.clipsToBounds = true
    coverImage.layer.borderColor = UIColor.lightGray.cgColor
    coverImage.layer.borderWidth = 0.5
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
