//
//  ZDNiceCommonViewController.swift
//  NiceApp
//
//  Created by 边振东 on 8/8/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ZDNiceCommonViewController: UIViewController {
  
  fileprivate let bottomHeight : CGFloat = 100.0
  fileprivate var briefCollection: UICollectionView!
  fileprivate var iconCollection:  UICollectionView!
  fileprivate var dataSource = [JSON]()
  fileprivate let defaultPageSize = 10
  fileprivate var currentPage = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UI_COLOR_DEFAULT
    self.setupUI()
    self.fetchDataSource()
  }
  
  private func setupUI() {
    self.setupNav()
    self.setupBriefCollection()
    self.setupIconCollection()
  }
  private func setupNav() {
    
  }
  
  private func setupBriefCollection() {
    self.briefCollection = briefCollectionView
    self.view.addSubview(self.briefCollection)
    briefCollection.snp.makeConstraints { (make) in
      make.top.equalTo(self.view)
      make.bottom.equalTo(self.view).offset(-self.bottomHeight)
      make.left.right.equalTo(self.view)
    }
  }
  
  private func setupIconCollection() {
    
  }
  
  private func fetchDataSource() {
    let baseUrl = ZDAPIConfig.API_Server + "apps/app/daily"
    var parameters = ZDAPIConfig.API_Parameters
    parameters["page"] = String(currentPage)
    parameters["page_size"] = String(defaultPageSize)
    Alamofire.request(baseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        self.dataSource = json["data"]["apps"].arrayValue
        self.briefCollection.reloadData()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private lazy var briefCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    layout.itemSize = CGSize.init(width: kSCREEN_WIDTH - 10, height: kSCREEN_HEIGHT - self.bottomHeight - 64 - 5)
    layout.scrollDirection = UICollectionViewScrollDirection.horizontal
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    
    let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
    collection.delegate = self
    collection.dataSource = self
    collection.showsHorizontalScrollIndicator = false
    collection.isPagingEnabled = true
    collection.register(UINib(nibName: "ZDCommonBriefCell", bundle: nil), forCellWithReuseIdentifier: "ZDCommonBriefCell")
    collection.backgroundColor = UIColor.clear
    
    return collection
  }()
}

// MARK: - UICollectionViewDelegate
extension ZDNiceCommonViewController: UICollectionViewDelegate {
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let index : Int = Int((scrollView.contentOffset.x) / kSCREEN_WIDTH)
//    if index < dataSource.count - 1 && index >= 0 {
//      var model = dataSource[index]
//      var notification = Notification.init(name: NotifyColor)
//      notification.object = model["recommanded_background_color"].stringValue
//      NotificationCenter.default.post(notification)
//    }
//  }
}

// MARK: - UICollectionViewDataSource
extension ZDNiceCommonViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZDCommonBriefCell", for: indexPath) as! ZDCommonBriefCell
    var model = dataSource[indexPath.item]
    let title : NSString = model["title"].stringValue as NSString
    cell.title.text = title as String
    let size = title.size(attributes: [NSFontAttributeName : cell.title.font])
    cell.titleWidth.constant = size.width + 5
    cell.subtitle.text = model["sub_title"].stringValue
    cell.coverImage.kf.setImage(with: URL(string: model["cover_image"].stringValue),
                                   placeholder: nil,
                                   options: [.transition(.fade(1))],
                                   progressBlock: nil,
                                   completionHandler: nil)
    cell.coverImageHeight.constant = (kSCREEN_WIDTH - 10) / (640.0 / 360.0)
    
    cell.authorUsername.text = model["author_username"].stringValue
    
    let digest = model["digest"].stringValue
    let digestAttText = NSMutableAttributedString.init(string: digest)
    let range = NSMakeRange(0, digestAttText.length)
    digestAttText.addAttribute(NSFontAttributeName, value: cell.digest.font, range: range)
    digestAttText.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: range)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 3.0
    digestAttText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
    let rect = digestAttText.boundingRect(with: CGSize.init(width: kSCREEN_WIDTH - 10 - 36, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
    cell.digest.attributedText = digestAttText
    cell.digestHeight.constant = rect.height + 5
    cell.upusersCount.text = String(model["info"]["up_users"].arrayValue.count)
    return cell
  }
}
