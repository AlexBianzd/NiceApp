//
//  ZDBottomToolView.swift
//  NiceApp
//
//  Created by 边振东 on 27/11/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDBottomToolView: UIScrollView {

  fileprivate var animateEnd = true
  
  override init(frame: CGRect)  {
    super.init(frame:frame)
    self.showsHorizontalScrollIndicator = false
    self.isPagingEnabled = true
    self.bounces = false
    self.contentSize = CGSize.init(width: UIScreen.main.bounds.width * 2, height: 0)
    
    let upView : UIView = Bundle.main.loadNibNamed("ZDUpToolView", owner: nil, options: nil)!.first as! UIView
    upView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
    self.addSubview(upView)
    
    let commentView : UIView = Bundle.main.loadNibNamed("ZDCommentToolView", owner: nil, options: nil)!.first as! UIView
    commentView.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: 44)
    self.addSubview(commentView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
    if animated {
      if animateEnd {
        animateEnd = false
        super.setContentOffset(contentOffset, animated: animated)
      }
      if self.contentOffset.x == contentOffset.x {
        animateEnd = true
      }
    } else {
      super.setContentOffset(contentOffset, animated: animated)
    }
  }
}
