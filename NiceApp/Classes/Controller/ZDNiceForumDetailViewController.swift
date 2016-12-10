//
//  ZDNiceForumDetailViewController.swift
//  NiceApp
//
//  Created by 边振东 on 8/14/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit
import SwiftyJSON

class ZDNiceForumDetailViewController: UIViewController {
  
  fileprivate var datasource = [String:JSON]()
  fileprivate var comments = [JSON]()
  fileprivate var container  = UIView()
  
  init(datasource : Dictionary<String,JSON>) {
    super.init(nibName: nil, bundle: nil)
    self.datasource = datasource
    self.comments = datasource["comments"]!.arrayValue
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
    backBtn.setImage(UIImage.init(named: "cnb_back"), for: .normal)
    backBtn.setImage(UIImage.init(named: "cnb_back_highlight"), for: .highlighted)
    backBtn.layer.cornerRadius = 35 / 2;
    backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
    self.view.addSubview(backBtn)
    backBtn.snp.makeConstraints { (make) in
      make.width.height.equalTo(35)
      make.centerX.equalTo(self.view.snp.left).offset(44 / 2)
      make.centerY.equalTo(self.view.snp.top).offset(44 / 2 + 20)
    }
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
  
  //MARK: UI
  private func setupUI() {
    self.view.backgroundColor = .white
    
    let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 44), style: .grouped)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
    tableView.register(UINib(nibName: "ZDCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "ZDCommentTableViewCell")
    self.view.addSubview(tableView)
    
    container.frame = self.view.bounds
    self.view.addSubview(container)
    var contentY : CGFloat = 0
    container.addSubview(authorAvatar)
    authorAvatar.snp.makeConstraints { (make) in
      make.width.height.equalTo(35)
      make.centerX.equalTo(container.snp.right).offset(-44 / 2)
      make.centerY.equalTo(container.snp.top).offset(44 / 2)
    }
    container.addSubview(authorName)
    authorName.snp.makeConstraints { (make) in
      make.width.equalTo(150)
      make.height.equalTo(35 / 2)
      make.right.equalTo(authorAvatar.snp.left).offset(-10)
      make.bottom.equalTo(authorAvatar.snp.centerY)
    }
    container.addSubview(authorCareer)
    authorCareer.snp.makeConstraints { (make) in
      make.width.equalTo(150)
      make.height.equalTo(35 / 2)
      make.right.equalTo(authorAvatar.snp.left).offset(-10)
      make.top.equalTo(authorAvatar.snp.centerY)
    }
    let separatorLine = UIView.init(frame: CGRect.init(x: 0, y: 44, width: container.bounds.width, height: 1))
    separatorLine.backgroundColor = UIColor.lightGray
    container.addSubview(separatorLine)
    contentY += 44
    container.addSubview(iconImage)
    iconImage.snp.makeConstraints { (make) in
      make.width.height.equalTo(50)
      make.left.equalTo(container).offset(15)
      make.top.equalTo(separatorLine.snp.bottom).offset(15)
    }
    container.addSubview(appName)
    appName.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.centerY.equalTo(iconImage)
      make.left.equalTo(iconImage.snp.right).offset(10)
      make.right.equalTo(self.view).offset(-10)
    }
    contentY += 15 + 50
    let rect = self.setupDescriptionUI()
    contentY += 60 + rect.size.height
    contentY += 10
    contentY = self.setupImagesUI(contentY: &contentY)
    contentY = self.setupUpUsersUI(contentY: &contentY)
    contentY += 10
    
    if self.comments.count > 0 {
      let commentLabel = UILabel()
      commentLabel.frame = CGRect.init(x: 10, y: contentY, width: 35, height: 20)
      commentLabel.font = UIFont.systemFont(ofSize: 16)
      commentLabel.text = "评论"
      commentLabel.textColor = UIColor.black
      container.addSubview(commentLabel)
      
      let line = UIView()
      line.frame = CGRect.init(x: commentLabel.frame.maxX + 10, y: commentLabel.center.y, width: kSCREEN_WIDTH - commentLabel.frame.maxX - 20, height: 1)
      line.backgroundColor = UIColor.lightGray
      container.addSubview(line)
      
      contentY = commentLabel.frame.maxY+10;
    }
    
    container.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: contentY)
    tableView.tableHeaderView = container

    let footer = ZDTableViewFooterView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
    tableView.tableFooterView = footer
    
    self.view.addSubview(bottomToolView)
  }
  
  private func setupDescriptionUI() -> CGRect {
    let descriptionText = datasource["description"]?.stringValue.replacingOccurrences(of: "<br/>", with: "\n")
    let descriptionAttText = NSMutableAttributedString.init(string: descriptionText!)
    let range = NSMakeRange(0, descriptionAttText.length)
    descriptionAttText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: range)
    descriptionAttText.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: range)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 5.0
    descriptionAttText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
    let description = UILabel()
    description.attributedText = descriptionAttText
    description.numberOfLines = 0
    container.addSubview(description)
    let rect = descriptionAttText.boundingRect(with: CGSize.init(width: kSCREEN_WIDTH - 20, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
    description.snp.makeConstraints { (make) in
      make.top.equalTo(appName.snp.bottom).offset(60)
      make.height.equalTo(rect.size.height)
      make.left.equalTo(container).offset(10)
      make.right.equalTo(container).offset(-10)
    }
    return rect
  }
  
  private func setupImagesUI(contentY: inout CGFloat) -> CGFloat {
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
    return contentY
  }
  
  private func setupUpUsersUI(contentY: inout CGFloat) -> CGFloat {
    let up_users = datasource["up_users"]?.arrayValue
    if up_users?.count != 0 {
      let up_user = UILabel()
      up_user.font = UIFont.systemFont(ofSize: 16)
      up_user.text = "美过的美友"
      up_user.textColor = UIColor.black
      container.addSubview(up_user)
      up_user.frame = CGRect.init(x: 10, y: contentY + 5, width: 80, height: 20)
      
      let line = UIView()
      line.backgroundColor = UIColor.lightGray
      container.addSubview(line)
      line.frame = CGRect.init(x: up_user.frame.maxX + 10, y: up_user.center.y, width: kSCREEN_WIDTH - up_user.frame.maxX - 20, height: 1)
      contentY = up_user.frame.maxY+10;
      
      let imgMargin : CGFloat = (kSCREEN_WIDTH-2*10-8*36)/7
      if up_users!.count <= 18 {
        for i in 0..<up_users!.count {
          let userImg = UIImageView.init()
          userImg.layer.cornerRadius = 18
          userImg.clipsToBounds = true
          userImg.frame = CGRect.init(x: 10+CGFloat(i%8)*(36+imgMargin),
                                      y: contentY + (36+imgMargin) * CGFloat(i/8),
                                      width: 36,
                                      height: 36)
          container.addSubview(userImg)
          userImg.kf.setImage(with: URL(string:up_users![i]["avatar_url"].stringValue),
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
          if i == (up_users?.count)! - 1 {
            contentY = userImg.frame.maxY;
          }
        }
      } else {
        let upusersContainer = UIScrollView()
        upusersContainer.showsHorizontalScrollIndicator = false
        upusersContainer.frame = CGRect.init(x: 0, y: contentY, width: kSCREEN_WIDTH, height: 36 * 2 + imgMargin)
        upusersContainer.contentSize = CGSize.init(width:  10+NSInteger(up_users!.count/2)*NSInteger(36+imgMargin), height: 0)
        container.addSubview(upusersContainer)
        for i in 0..<up_users!.count {
          let userImg = UIImageView.init()
          userImg.layer.cornerRadius = 18
          userImg.clipsToBounds = true
          userImg.frame = CGRect.init(x: 10+CGFloat(NSInteger(i/2)%NSInteger(up_users!.count/2))*(36+imgMargin),
                                      y: CGFloat(i%2)*(36+imgMargin),
                                      width: 36,
                                      height: 36)
          upusersContainer.addSubview(userImg)
          userImg.kf.setImage(with: URL(string:up_users![i]["avatar_url"].stringValue),
                              placeholder: nil,
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        }
        contentY += upusersContainer.bounds.size.height
      }
    }
    return contentY
  }
  
  //MARK: private method
  private func sizeWithUrl(_ url : String) -> CGSize {
    let start = url.characters.index(after: url.characters.index(of: "_")!)
    let end = url.characters.index(of: "?")
    var c = url.substring(to: end!).substring(from: start)
    let dot = c.characters.index(of: ".")
    c = c.substring(to: dot!)
    let x = c.characters.index(of: "x")
    let imgWidth  = Float(c.substring(to: x!))
    let imgHeight = Float(c.substring(from: c.characters.index(after: x!)))
    let width  = kSCREEN_WIDTH - 20
    let height = width * CGFloat(imgHeight! / imgWidth!)
    return CGSize.init(width: width, height: height)
  }
  
  //MARK: Lazy
  lazy var authorAvatar: UIImageView = {
    let authorAvatar = UIImageView()
    authorAvatar.clipsToBounds = true
    authorAvatar.layer.cornerRadius = 35 / 2
    authorAvatar.kf.setImage(with: URL(string: (self.datasource["author_avatar_url"]?.stringValue)!),
                             placeholder: nil,
                             options: [.transition(.fade(1))],
                             progressBlock: nil,
                             completionHandler: nil)
    return authorAvatar
  }()
  
  lazy var authorName: UILabel = {
    let authorName = UILabel()
    authorName.font = UIFont.systemFont(ofSize: 13)
    authorName.textColor = UIColor.black
    authorName.textAlignment = .right
    authorName.text = self.datasource["author_name"]?.stringValue
    return authorName
  }()
  
  lazy var authorCareer: UILabel = {
    let authorCareer = UILabel()
    authorCareer.font = UIFont.systemFont(ofSize: 12)
    authorCareer.textColor = UIColor.gray
    authorCareer.textAlignment = .right
    authorCareer.text = self.datasource["author_career"]?.stringValue
    return authorCareer
  }()
  
  lazy var iconImage: UIImageView = {
    let iconImage = UIImageView()
    iconImage.clipsToBounds = true
    iconImage.layer.cornerRadius = 10
    iconImage.kf.setImage(with: URL(string: (self.datasource["icon_image"]?.stringValue)!),
                          placeholder: nil,
                          options: [.transition(.fade(1))],
                          progressBlock: nil,
                          completionHandler: nil)
    return iconImage
  }()
  
  lazy var appName: UILabel = {
    let appName = UILabel()
    appName.font = UIFont.systemFont(ofSize: 18)
    appName.textColor = UIColor.black
    appName.textAlignment = .left
    appName.text = self.datasource["app_name"]?.stringValue
    appName.numberOfLines = 0
    return appName
  }()
  
  lazy var bottomToolView: ZDBottomToolView = {
    let bottomToolView = ZDBottomToolView.init(frame: CGRect.init(x: 0, y: kSCREEN_HEIGHT - 44, width: kSCREEN_WIDTH, height: 44))
    return bottomToolView
  }()
}

// MARK: - UITableViewDelegate
extension ZDNiceForumDetailViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > scrollView.contentSize.height / 2 {
      bottomToolView.setContentOffset(CGPoint.init(x: self.view.bounds.width, y: 0), animated: true)
    } else {
      bottomToolView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
  return 10
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.001
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let content = self.comments[indexPath.section]["content"].stringValue.replacingOccurrences(of: "<br/>", with: "\n").replacingOccurrences(of: "<br />", with: "\n")
    let contentAttText = NSMutableAttributedString.init(string: content)
    let range = NSMakeRange(0, contentAttText.length)
    contentAttText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: range)
    let rect = contentAttText.boundingRect(with: CGSize.init(width: kSCREEN_WIDTH - 20, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
    return rect.size.height + 15 + 23 + 30
  }
}

// MARK: - UITableViewDataSource
extension ZDNiceForumDetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    let count = self.comments.last?["count"].intValue
    if self.comments.count == count || self.comments.count == 0 {
      tableView.tableFooterView = nil
    }
    return self.comments.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ZDCommentTableViewCell", for: indexPath) as! ZDCommentTableViewCell
    var model = self.comments[indexPath.section]
    cell.author_avatar.kf.setImage(with: URL(string: (model["author_avatar_url"].stringValue)),
                                   placeholder: nil,
                                   options: [.transition(.fade(1))],
                                   progressBlock: nil,
                                   completionHandler: nil)
    cell.author_name.text = model["author_name"].stringValue
    cell.author_career.text = model["author_career"].stringValue
    cell.updated_at.text = model["updated_at"].stringValue
    let content = model["content"].stringValue.replacingOccurrences(of: "<br/>", with: "\n").replacingOccurrences(of: "<br />", with: "\n")
    cell.content.text = content
    return cell
  }
}
