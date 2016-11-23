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
    self.view.backgroundColor = UIColor.white
    self.navigationController?.navigationBar.isHidden = true
    self.setupUI()
    let backBtn = UIButton.init(type: .custom)
    backBtn.frame = CGRect.init(x: 15, y: 15, width: 35, height: 35)
    backBtn.backgroundColor = UIColor.blue
    backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
    self.view.addSubview(backBtn)
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
    
    var contentY : CGFloat = 0
    
    let authorAvatar = UIImageView()
    authorAvatar.clipsToBounds = true
    authorAvatar.layer.cornerRadius = 35 / 2
    authorAvatar.kf.setImage(with: URL(string: (datasource["author_avatar_url"]?.stringValue)!),
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
    authorName.text = datasource["author_name"]?.stringValue
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
    authorCareer.text = datasource["author_career"]?.stringValue
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
    
    contentY += 64
    
    let iconImage = UIImageView()
    iconImage.clipsToBounds = true
    iconImage.layer.cornerRadius = 10
    iconImage.kf.setImage(with: URL(string: (datasource["icon_image"]?.stringValue)!),
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
    appName.text = datasource["app_name"]?.stringValue
    appName.numberOfLines = 0
    container.addSubview(appName)
    appName.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.centerY.equalTo(iconImage)
      make.left.equalTo(iconImage.snp.right).offset(10)
      make.right.equalTo(self.view).offset(-10)
    }
    
    contentY += 15 + 50
    
    let descriptionText = datasource["description"]?.stringValue.replacingOccurrences(of: "<br/>", with: "\n")
    let descriptionAttText = NSMutableAttributedString.init(string: descriptionText!)
    let range = NSMakeRange(0, descriptionAttText.length)
    descriptionAttText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range)
    descriptionAttText.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: range)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 5.0
    descriptionAttText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
    let rect = descriptionAttText.boundingRect(with: CGSize.init(width: self.view.bounds.size.width - 20, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
    let description = UILabel()
    description.attributedText = descriptionAttText
    description.numberOfLines = 0
    container.addSubview(description)
    description.snp.makeConstraints { (make) in
      make.top.equalTo(appName.snp.bottom).offset(60)
      make.height.equalTo(rect.size.height)
      make.left.equalTo(self.view).offset(10)
      make.right.equalTo(self.view).offset(-10)
    }
    
    contentY += 60 + rect.size.height
    
    contentY += 10 
    let all_images = datasource["all_images"]?.arrayValue
    for i in 0..<all_images!.count {
      let url : String = all_images![i].stringValue
      let size : CGSize = self.sizeWithUrl(url)
      let imgView = UIImageView.init()
      imgView.frame = CGRect.init(origin: CGPoint.init(x: 10, y: contentY), size: size)
      imgView.layer.borderColor = UIColor.lightGray.cgColor
      imgView.layer.borderWidth = 0.5
      container.addSubview(imgView)
      imgView.kf.setImage(with: URL(string:url),
                          placeholder: nil,
                          options: [.transition(.fade(1))],
                          progressBlock: nil,
                          completionHandler: nil)
      contentY += size.height + 10
    }
    
    container.contentSize = CGSize.init(width: 0, height: contentY)
  }
  
  func sizeWithUrl(_ url : String) -> CGSize {
    let start = url.characters.index(after: url.characters.index(of: "_")!)
    let end = url.characters.index(of: "?")
    var c = url.substring(to: end!).substring(from: start)
    let dot = c.characters.index(of: ".")
    c = c.substring(to: dot!)
    let x = c.characters.index(of: "x")
    let imgWidth  = Float(c.substring(to: x!))
    let imgHeight = Float(c.substring(from: c.characters.index(after: x!)))
    let width  = self.view.bounds.size.width - 20
    let height = width * CGFloat(imgHeight! / imgWidth!)
    return CGSize.init(width: width, height: height)
  }
}
