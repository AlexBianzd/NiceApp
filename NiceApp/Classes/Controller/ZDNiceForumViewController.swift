//
//  ZDNiceForumViewController.swift
//  NiceApp
//
//  Created by 边振东 on 8/14/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ZDNiceForumViewController: UIViewController {
  
  fileprivate var titleSegment: UISegmentedControl!
  fileprivate var containerScrollView: UIScrollView!
  fileprivate var hotTableView: UITableView!
  fileprivate var recentTableView: UITableView!
  fileprivate var hotTableFooterView: ZDTableViewFooterView!
  fileprivate var recentTableFooterView: ZDTableViewFooterView!
  fileprivate var hotRefreshControl: UIRefreshControl!
  fileprivate var recentRefeshControl: UIRefreshControl!
  
  fileprivate var hotRecommendData = [JSON]()
  fileprivate var recentRecommendData = [JSON]()
  
  fileprivate let defaultPageSize = 6
  fileprivate var hotPage = 1
  fileprivate var hotIsLoadingMore = false
  fileprivate var recentIsLoadingMore = false
  fileprivate var hotIsRefreshing = false
  fileprivate var recentIsRefreshing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UI_COLOR_DEFAULT
    
    self.setupUI()
    self.fetchHotRecommendData()
    self.fetchRecentRecommendData()
  }
  
  fileprivate func setupUI() {
    titleSegment = UISegmentedControl.init(items: ["最热分享", "最近分享"])
    titleSegment.setWidth(80, forSegmentAt: 0)
    titleSegment.setWidth(80, forSegmentAt: 1)
    titleSegment.tintColor = Color.white
    titleSegment.selectedSegmentIndex = 0
    self.navigationItem.titleView = titleSegment
    titleSegment.addTarget(self, action: #selector(scrollToViewAtSegIndex), for: .valueChanged)
    
    containerScrollView = UIScrollView(frame: self.view.bounds)
    containerScrollView.delegate = self
    containerScrollView.contentSize = CGSize(width: self.view.bounds.size.width * 2, height: 0)
    containerScrollView.isPagingEnabled = true
    containerScrollView.bounces = false
    containerScrollView.showsHorizontalScrollIndicator = false
    self.view.addSubview(containerScrollView)
    containerScrollView.snp.makeConstraints { (make) in
      make.top.equalTo(self.view)
      make.left.right.bottom.equalTo(self.view)
    }
    
    hotTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), style: .grouped)
    hotTableView.delegate = self
    hotTableView.dataSource = self
    hotTableView.backgroundColor = Color.clear
    hotTableView.separatorStyle = .none
    hotTableView.showsVerticalScrollIndicator = false
    hotTableView!.register(UINib(nibName: "ZDForumTableViewCell", bundle: nil), forCellReuseIdentifier: "ZDForumTableViewCell")
    containerScrollView.addSubview(hotTableView)
    hotRefreshControl = UIRefreshControl.init()
    hotRefreshControl.addTarget(self, action:#selector(refreshHotRecommendData), for: .valueChanged)
    hotTableView.addSubview(hotRefreshControl)
    
    recentTableView = UITableView.init(frame: CGRect(x: self.view.bounds.size.width, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), style: .grouped)
    recentTableView.delegate = self
    recentTableView.dataSource = self
    recentTableView.backgroundColor = Color.clear
    recentTableView.separatorStyle = .none
    recentTableView.showsVerticalScrollIndicator = false
    recentTableView!.register(UINib(nibName: "ZDForumTableViewCell", bundle: nil), forCellReuseIdentifier: "ZDForumTableViewCell")
    containerScrollView.addSubview(recentTableView)
    recentRefeshControl = UIRefreshControl.init()
    recentRefeshControl.addTarget(self, action:#selector(refreshRecentRecommendData), for: .valueChanged)
    recentTableView.addSubview(recentRefeshControl)
  }
  
  func refreshHotRecommendData() {
    if !hotIsRefreshing {
      hotPage = 1;
      self.hotRecommendData.removeAll()
      self.fetchHotRecommendData()
    }
  }
  
  func refreshRecentRecommendData() {
    if !recentIsRefreshing {
      self.recentRecommendData.removeAll()
      self.fetchRecentRecommendData()
    }
  }
  
  fileprivate func fetchHotRecommendData() {
    hotIsRefreshing  = true
    hotIsLoadingMore = true
    let baseHotUrl = ZDAPIConfig.API_Server + "community/recommend_apps"
    var parameters = ZDAPIConfig.API_Parameters
    parameters["page"] = String(hotPage)
    parameters["page_size"] = String(defaultPageSize)
    Alamofire.request(baseHotUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        let hadNext = json["data"]["has_next"].boolValue
        if hadNext {
          if self.hotTableView.tableFooterView == nil {
            self.hotTableFooterView = ZDTableViewFooterView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
            self.hotTableView.tableFooterView = self.hotTableFooterView
          }
        } else {
          self.hotTableView.tableFooterView = nil;
        }
        self.hotRecommendData.append(contentsOf: json["data"]["apps"].arrayValue)
        self.hotTableView.reloadData()
      case .failure(let error):
        print(error)
      }
      self.hotIsLoadingMore = false
      self.hotIsRefreshing  = false
      self.hotRefreshControl.endRefreshing()
    }
  }
  fileprivate func fetchRecentRecommendData() {
    recentIsRefreshing  = true
    recentIsLoadingMore = true
    let baseRecentUrl = ZDAPIConfig.API_Server + "community/apps"
    var parameters = ZDAPIConfig.API_Parameters
    if self.recentRecommendData.count == 0 {
      parameters["pos"] = "-1"
    } else {
      let json = self.recentRecommendData.last
      parameters["pos"] = json?["pos"].stringValue
    }
    parameters["page_size"] = String(defaultPageSize)
    Alamofire.request(baseRecentUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        let hadNext = json["data"]["has_next"].boolValue
        if hadNext {
          if self.recentTableView.tableFooterView == nil {
            self.recentTableFooterView = ZDTableViewFooterView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
            self.recentTableFooterView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
            self.recentTableView.tableFooterView = self.recentTableFooterView
          }
        } else {
          self.recentTableView.tableFooterView = nil;
        }
        self.recentRecommendData.append(contentsOf: json["data"]["apps"].arrayValue)
        self.recentTableView.reloadData()
      case .failure(let error):
        print(error)
      }
      self.recentIsLoadingMore = false
      self.recentIsRefreshing  = false
      self.recentRefeshControl.endRefreshing()
    }
  }
  
  func scrollToViewAtSegIndex() {
    let index = self.titleSegment.selectedSegmentIndex
    containerScrollView.setContentOffset(CGPoint(x: self.view.bounds.size.width * CGFloat(index), y:containerScrollView.contentOffset.y), animated: true)
  }
}

// MARK: - UITableViewDelegate
extension ZDNiceForumViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == containerScrollView {
      return
    }
    
    let height = scrollView.frame.size.height
    let contentYOffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYOffset
    if scrollView == hotTableView {
      if distanceFromBottom < height && !hotIsLoadingMore {
        hotPage += 1
        self.fetchHotRecommendData()
      }
    } else if scrollView == recentTableView {
      if distanceFromBottom < height && !recentIsLoadingMore {
        self.fetchRecentRecommendData()
      }
    }
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    let index = containerScrollView.contentOffset.x / containerScrollView.bounds.size.width
    titleSegment.selectedSegmentIndex = Int(index)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.scrollViewDidEndScrollingAnimation(scrollView)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 350
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 12
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    switch self.titleSegment.selectedSegmentIndex {
    case 0:
      if section < self.hotRecommendData.count - 1 {
        return 0.0001
      }
    case 1:
      if section < self.recentRecommendData.count - 1 {
        return 0.0001
      }
    default:
      break
    }
    return 12
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch self.titleSegment.selectedSegmentIndex {
    case 0:
      let detail = ZDNiceForumDetailViewController(datasource:self.hotRecommendData[indexPath.section].dictionaryValue)
      self.navigationController!.pushViewController(detail, animated: true)
      
    case 1:
      let detail = ZDNiceForumDetailViewController(datasource:self.recentRecommendData[indexPath.section].dictionaryValue)
      self.navigationController!.pushViewController(detail, animated: true)
      
    default:
      break
    }
  }
}


// MARK: - UITableViewDataSource
extension ZDNiceForumViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    switch self.titleSegment.selectedSegmentIndex {
    case 0:
      return self.hotRecommendData.count
    case 1:
      return self.recentRecommendData.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ZDForumTableViewCell", for: indexPath) as! ZDForumTableViewCell
    var json = JSON.init(nilLiteral: ())
    if tableView == self.hotTableView {
      if self.hotRecommendData.count > indexPath.section {
        json = self.hotRecommendData[indexPath.section]
      } else {
        return cell
      }
    }
    if tableView == self.recentTableView {
      if self.recentRecommendData.count > indexPath.section {
        json = self.recentRecommendData[indexPath.section]
      } else {
        return cell
      }
    }
    
    cell.authorAvatar.kf.setImage(with: URL(string: json["author_avatar_url"].stringValue),
                                  placeholder: nil,
                                  options: [.transition(.fade(1))],
                                  progressBlock: nil,
                                  completionHandler: nil)
    cell.authorName.text = json["author_name"].stringValue
    cell.authorCareer.text = json["author_career"].stringValue
    cell.coverImage.kf.setImage(with: URL(string: json["cover_image"].stringValue),
                                placeholder: nil,
                                options: [.transition(.fade(1))],
                                progressBlock: nil,
                                completionHandler: nil)
    cell.iconImage.kf.setImage(with: URL(string: json["icon_image"].stringValue),
                               placeholder: nil,
                               options: [.transition(.fade(1))],
                               progressBlock: nil,
                               completionHandler: nil)
    cell.appName.text = json["app_name"].stringValue
    cell.appDescription.text = json["description"].stringValue
    cell.browse.text = json["show_times"].stringValue
    cell.flower.text = json["up_times"].stringValue
    cell.comment.text = json["comment_times"].stringValue
    return cell
  }
}
