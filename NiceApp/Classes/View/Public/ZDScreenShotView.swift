//
//  ZDScreenShotView.swift
//  NiceApp
//
//  Created by 边振东 on 14/11/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDScreenShotView: UIView {

  var imgView : UIImageView!
  var coverView : UIView!
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .black
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func setupSubviews() {
    self.imgView = UIImageView(frame:self.bounds)
    self.coverView = UIView(frame:self.bounds)
    coverView.backgroundColor = UIColor.init(hue: 0, saturation: 0, brightness: 0, alpha: 0.4)
    self.addSubview(imgView)
    self.addSubview(coverView)
  }
  
  func showEffectChange(point : CGPoint) {
    if point.x > 0 {
      coverView.backgroundColor = UIColor.init(hue: 0, saturation: 0, brightness: 0, alpha: -point.x / self.bounds.size.width * 0.4 + 0.4)
      imgView.transform = CGAffineTransform.init(scaleX: 0.95 + (point.x / self.bounds.size.width * 0.05), y: 0.95 + (point.x / self.bounds.size.width * 0.05))
    }
  }
  
  func restore() {
    if coverView != nil && imgView != nil {
      coverView.backgroundColor = UIColor.init(hue: 0, saturation: 0, brightness: 0, alpha: 0.4)
      imgView.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
    }
  }
  
  func screenShot() {
    UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, 0)
    UIApplication.shared.keyWindow?.layer.render(in: UIGraphicsGetCurrentContext()!)
    let viewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    imgView.image = viewImage
    imgView.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
  }
}
