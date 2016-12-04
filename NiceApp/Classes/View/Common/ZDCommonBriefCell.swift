//
//  ZDCommonBriefCell.swift
//  NiceApp
//
//  Created by AlexBian on 04/12/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDCommonBriefCell: UICollectionViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var titleWidth: NSLayoutConstraint!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var coverImage: UIImageView!  
  @IBOutlet weak var coverImageHeight: NSLayoutConstraint!
  @IBOutlet weak var authorUsername: UILabel!
  @IBOutlet weak var digest: UILabel!
  @IBOutlet weak var digestHeight: NSLayoutConstraint!
  @IBOutlet weak var upusersCount: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.cornerRadius = 3
  }
}
