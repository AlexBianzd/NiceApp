//
//  ZDBaseView.swift
//  NiceApp
//
//  Created by 边振东 on 27/11/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

@IBDesignable
class ZDBaseView: UIView {

  @IBInspectable var cornerRadius : CGFloat = 0 {
    didSet{
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
  @IBInspectable var borderWidth : CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable var borderColor : UIColor? {
    didSet {
      layer.borderColor = borderColor?.cgColor
    }
  }
}
