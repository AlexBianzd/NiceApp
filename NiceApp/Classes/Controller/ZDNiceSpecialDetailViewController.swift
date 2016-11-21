//
//  ZDNiceSpecialDetailViewController.swift
//  NiceApp
//
//  Created by 边振东 on 8/14/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit
import SwiftyJSON

class ZDNiceSpecialDetailViewController: UIViewController {
  
  fileprivate var datasource = [String:JSON]()
  fileprivate var container  = UIScrollView()
  
  init(datasource : Dictionary<String,JSON>) {
    super.init(nibName: nil, bundle: nil)
    self.datasource = datasource
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.green
    self.navigationController?.navigationBar.isHidden = true
    let backBtn = UIButton.init(type: .custom)
    backBtn.frame = CGRect.init(x: 15, y: 15, width: 35, height: 35)
    backBtn.backgroundColor = UIColor.blue
    backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
    self.view.addSubview(backBtn)
    self.setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  func back() {
    let navCon = self.navigationController as! ZDBaseNavigationController
    navCon.touchBack()
  }
  
  func setupUI() {
    container.frame = self.view.bounds
    self.view.addSubview(container)
    
    let authorAvatar = UIImageView()
    authorAvatar.clipsToBounds = true
    authorAvatar.layer.cornerRadius = 35 / 2
    authorAvatar.kf.setImage(with: URL(string: (self.datasource["author_avatar_url"]?.stringValue)!),
                             placeholder: nil,
                             options: [.transition(.fade(1))],
                             progressBlock: nil,
                             completionHandler: nil)
    container.addSubview(authorAvatar)
    authorAvatar.snp.makeConstraints { (make) in
      make.width.height.equalTo(35)
      make.centerX.equalTo(self.view.snp.right).offset(-44 / 2)
      make.centerY.equalTo(container.snp.top).offset(20 + 44 / 2)
    }
    
    let authorName = UILabel()
    authorName.font = UIFont.systemFont(ofSize: 13)
    authorName.textColor = UIColor.black
    authorName.textAlignment = .right
    authorName.text = self.datasource["author_name"]?.stringValue
    container.addSubview(authorName)
    authorName.snp.makeConstraints { (make) in
      make.width.equalTo(150)
      make.height.equalTo(35 / 2)
      make.right.equalTo(authorAvatar.snp.left).offset(-10)
      make.bottom.equalTo(authorAvatar.snp.centerY)
    }
    
    let authorCareer = UILabel()
    authorCareer.font = UIFont.systemFont(ofSize: 12)
    authorCareer.textColor = UIColor.gray
    authorCareer.textAlignment = .right
    authorCareer.text = self.datasource["author_career"]?.stringValue
    container.addSubview(authorCareer)
    authorCareer.snp.makeConstraints { (make) in
      make.width.equalTo(150)
      make.height.equalTo(35 / 2)
      make.right.equalTo(authorAvatar.snp.left).offset(-10)
      make.top.equalTo(authorAvatar.snp.centerY)
    }
    
    let separatorLine = UIView.init(frame: CGRect.init(x: 0, y: 64, width: container.bounds.size.width, height: 1))
    separatorLine.backgroundColor = UIColor.lightGray
    container.addSubview(separatorLine)
    
    let iconImage = UIImageView()
    iconImage.clipsToBounds = true
    iconImage.layer.cornerRadius = 10
    iconImage.kf.setImage(with: URL(string: (self.datasource["icon_image"]?.stringValue)!),
                          placeholder: nil,
                          options: [.transition(.fade(1))],
                          progressBlock: nil,
                          completionHandler: nil)
    container.addSubview(iconImage)
    iconImage.snp.makeConstraints { (make) in
      make.width.height.equalTo(50)
      make.left.equalTo(container).offset(15)
      make.top.equalTo(separatorLine.snp.bottom).offset(15)
    }
    
    let appName = UILabel()
    appName.font = UIFont.systemFont(ofSize: 18)
    appName.textColor = UIColor.black
    appName.textAlignment = .left
    appName.text = self.datasource["app_name"]?.stringValue
    appName.numberOfLines = 0
    container.addSubview(appName)
    appName.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.centerY.equalTo(iconImage)
      make.left.equalTo(iconImage.snp.right).offset(10)
      make.right.equalTo(self.view).offset(-10)
    }
    
    let description = UILabel()
    description.backgroundColor = UIColor.blue
    container.addSubview(description)
    description.snp.makeConstraints { (make) in
      make.top.equalTo(appName.snp.bottom).offset(60)
      make.height.equalTo(1000)
      make.left.equalTo(self.view).offset(10)
      make.right.equalTo(self.view).offset(-10)
    }
    
    container.contentSize = CGSize.init(width: 0, height: 1000)
  }
}
