//
//  ZDTableViewFooterView.swift
//  NiceApp
//
//  Created by 边振东 on 27/11/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDTableViewFooterView: UIView {
  
  override init(frame: CGRect)  {
    super.init(frame:frame)
    let background = UIView.init()
    background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    background.layer.cornerRadius = 3
    self.addSubview(background)
    background.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(self)
      make.left.equalTo(self).offset(12)
      make.right.equalTo(self).offset(-12)
    }
    
    let titleView = UILabel.init()
    titleView.text = "加载更多"
    titleView.font = UIFont.systemFont(ofSize: 14)
    titleView.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    self.addSubview(titleView)
    titleView.snp.makeConstraints { (make) in
      make.center.equalTo(self)
      make.width.equalTo((60))
      make.height.equalTo((15))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
