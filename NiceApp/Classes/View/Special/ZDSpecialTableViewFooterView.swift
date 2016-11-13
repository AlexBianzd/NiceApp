//
//  ZDSpecialTableViewFooterView.swift
//  NiceApp
//
//  Created by 边振东 on 13/11/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDSpecialTableViewFooterView: UITableViewHeaderFooterView {
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    let background = UIView.init()
    background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    background.layer.cornerRadius = 3
    self.contentView .addSubview(background)
    background.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(self.contentView)
      make.left.equalTo(self.contentView).offset(12)
      make.right.equalTo(self.contentView).offset(-12)
    }
    
    let titleView = UILabel.init()
    titleView.text = "加载更多"
    titleView.font = UIFont.systemFont(ofSize: 14)
    titleView.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    self.contentView .addSubview(titleView)
    titleView.snp.makeConstraints { (make) in
      make.center.equalTo(self.contentView)
      make.width.equalTo((60))
      make.height.equalTo((15))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
