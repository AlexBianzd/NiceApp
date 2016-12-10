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
    self.view.addSubview(self.briefCollectionView)
    briefCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(self.view)
      make.bottom.equalTo(self.view).offset(-self.bottomHeight)
      make.left.right.equalTo(self.view)
    }
  }
  
  private func setupIconCollection() {
    self.view.addSubview(self.iconCollectionView)
    iconCollectionView.snp.makeConstraints { (make) in
      make.left.right.bottom.equalTo(self.view)
      make.height.equalTo(60)
    }
    
    let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(iconViewLongPress(sender:)))
    longPress.minimumPressDuration = 0
    iconCollectionView.addGestureRecognizer(longPress)
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
        self.briefCollectionView.reloadData()
        self.iconCollectionView.reloadData()
        self.perform(#selector(self.changeIconWithIndexPath(_:)), with: IndexPath.init(item: 0, section: 0), afterDelay: 0.3)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  lazy var briefCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    layout.itemSize = CGSize.init(width: kSCREEN_WIDTH - 10, height: kSCREEN_HEIGHT - self.bottomHeight - 64 - 5)
    layout.scrollDirection = UICollectionViewScrollDirection.horizontal
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    
    let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
    collection.tag = 100
    collection.delegate = self
    collection.dataSource = self
    collection.showsHorizontalScrollIndicator = false
    collection.isPagingEnabled = true
    collection.register(UINib(nibName: "ZDCommonBriefCell", bundle: nil), forCellWithReuseIdentifier: "ZDCommonBriefCell")
    collection.backgroundColor = UIColor.clear
    return collection
  }()
  
  lazy var iconCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    layout.itemSize = CGSize.init(width: 45, height: 60)
    layout.scrollDirection = UICollectionViewScrollDirection.horizontal
    layout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
    layout.minimumLineSpacing = 0
    
    let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
    collection.tag = 200
    collection.delegate = self
    collection.dataSource = self
    collection.showsHorizontalScrollIndicator = false
    collection.register(UINib(nibName: "ZDCommonIconCell", bundle: nil), forCellWithReuseIdentifier: "ZDCommonIconCell")
    collection.backgroundColor = UIColor.clear
    return collection
  }()
  
  func iconViewLongPress(sender : UILongPressGestureRecognizer) {
    let point = sender.location(in: iconCollectionView)
    let cells = iconCollectionView.visibleCells
    for cell in cells {
      if cell.frame.contains(point) {
        let index = iconCollectionView.indexPath(for: cell)?.item
        for i in index! - 4 ... index! + 4 {
          if i < 0 || i >= dataSource.count {
            continue
          }
          let indexPath = NSIndexPath.init(item: i, section: 0)
          let cell = iconCollectionView.cellForItem(at: indexPath as IndexPath) as? ZDCommonIconCell
          UIView.animate(withDuration: 0.25, animations: {
            cell?.container.transform = CGAffineTransform.init(translationX: 0, y: CGFloat(10 * abs(i - index!) - 40))
          })
        }
        break
      }
    }
    
    if sender.state == .ended || sender.state == .cancelled {
      for cell in cells {
        if cell.frame.contains(point) {
          let indexPath = iconCollectionView.indexPath(for: cell)
          self.changeIconWithIndexPath(indexPath!)
          self.briefCollectionView.scrollToItem(at: indexPath!, at: .centeredHorizontally, animated: false)
        }
      }
    }
  }
  
  func changeIconWithIndexPath(_ indexPath: IndexPath) {
    for i in 0..<self.iconCollectionView.subviews.count {
      let cell = iconCollectionView.cellForItem(at: IndexPath.init(item: i, section: 0)) as? ZDCommonIconCell
      var transform: CGAffineTransform
      if i == indexPath.item {
        transform = CGAffineTransform.init(translationX: 0, y: -35)
      } else {
        transform = CGAffineTransform.identity
      }
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 10,
                     options: UIViewAnimationOptions(rawValue: 0),
                     animations: {
                      cell?.container.transform = transform
      }, completion: nil)
    }
    
    var model = dataSource[indexPath.item]
    var notification = Notification.init(name: NotifyColor)
    notification.object = model["recommanded_background_color"].stringValue
    NotificationCenter.default.post(notification)
  }
}

// MARK: - UICollectionViewDelegate
extension ZDNiceCommonViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView.tag == 100 {
      let index : Int = Int((scrollView.contentOffset.x) / kSCREEN_WIDTH)
      if index < dataSource.count && index >= 0 {
        self.changeIconWithIndexPath(IndexPath.init(item: index, section: 0))
        self.iconCollectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)
      }
    }
  }
}

// MARK: - UICollectionViewDataSource
extension ZDNiceCommonViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.tag == 100 {
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
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZDCommonIconCell", for: indexPath) as! ZDCommonIconCell
      var model = dataSource[indexPath.item]
      cell.icon.kf.setImage(with: URL(string: model["icon_image"].stringValue),
                            placeholder: nil,
                            options: [.transition(.fade(1))],
                            progressBlock: nil,
                            completionHandler: nil)
      return cell
    }
  }
}
