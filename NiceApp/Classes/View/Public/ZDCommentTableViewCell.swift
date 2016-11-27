//
//  ZDCommentTableViewCell.swift
//  NiceApp
//
//  Created by 边振东 on 27/11/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDCommentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var author_avatar: UIImageView!
  @IBOutlet weak var author_name: UILabel!
  @IBOutlet weak var author_career: UILabel!
  @IBOutlet weak var updated_at: UILabel!
  @IBOutlet weak var content: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    author_avatar.layer.cornerRadius = 15
    author_avatar.clipsToBounds = true
    self.selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
