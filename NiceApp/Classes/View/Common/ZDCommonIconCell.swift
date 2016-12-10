//
//  ZDCommonIconCell.swift
//  NiceApp
//
//  Created by AlexBian on 08/12/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDCommonIconCell: UICollectionViewCell {

  @IBOutlet weak var container: UIView!
  @IBOutlet weak var icon: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      icon.layer.cornerRadius = 5
    }

}
