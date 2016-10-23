//
//  ZDNiceSpecialViewController.swift
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

class ZDNiceSpecialViewController: UIViewController {
  
  fileprivate var titleSegment: UISegmentedControl!
  fileprivate var containerScrollView: UIScrollView!
  fileprivate var hotTableView: UITableView!
  fileprivate var recentTableView: UITableView!
  
  fileprivate var hotRecommendData = [JSON]()
  fileprivate var recentRecommendData = [JSON]()
  
  fileprivate let defaultPageSize = 10
  fileprivate var hotPage = 1
  fileprivate var recentPage = 1
  
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
    hotTableView!.register(UINib(nibName: "ZDSpecialTableViewCell", bundle: nil), forCellReuseIdentifier: "ZDSpecialTableViewCell")
    containerScrollView.addSubview(hotTableView)
    
    recentTableView = UITableView.init(frame: CGRect(x: self.view.bounds.size.width, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64), style: .grouped)
    recentTableView.delegate = self
    recentTableView.dataSource = self
    recentTableView.backgroundColor = Color.clear
    recentTableView.separatorStyle = .none
    recentTableView.showsVerticalScrollIndicator = false
    recentTableView!.register(UINib(nibName: "ZDSpecialTableViewCell", bundle: nil), forCellReuseIdentifier: "ZDSpecialTableViewCell")
    containerScrollView.addSubview(recentTableView)
  }
  
  fileprivate func fetchHotRecommendData() {
    let baseHotUrl = ZDAPIConfig.API_Server + "community/recommend_apps"
    var parameters = ZDAPIConfig.API_Parameters
    parameters["page"] = String(hotPage)
    parameters["page_size"] = String(defaultPageSize)
    Alamofire.request(baseHotUrl, method: .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        self.hotRecommendData = json["data"]["apps"].arrayValue
        self.hotTableView.reloadData()
      case .failure(let error):
        print(error)
      }
      
    }
  }
  fileprivate func fetchRecentRecommendData() {
    let baseHotUrl = ZDAPIConfig.API_Server + "community/apps"
    var parameters = ZDAPIConfig.API_Parameters
    parameters["page"] = String(recentPage)
    parameters["page_size"] = String(defaultPageSize)
    Alamofire.request(baseHotUrl, method: .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
      switch response.result {
      case .success(let value):
        let json = JSON(value)
        self.recentRecommendData = json["data"]["apps"].arrayValue
        self.recentTableView.reloadData()
      case .failure(let error):
        print(error)
      }
      
    }
  }
  
  func scrollToViewAtSegIndex() {
    let index = self.titleSegment.selectedSegmentIndex
    containerScrollView.setContentOffset(CGPoint(x: self.view.bounds.size.width * CGFloat(index), y:containerScrollView.contentOffset.y), animated: true)
  }
}

// MARK: - UITableViewDelegate
extension ZDNiceSpecialViewController: UITableViewDelegate {
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    let index = containerScrollView.contentOffset.x / containerScrollView.bounds.size.width
    titleSegment.selectedSegmentIndex = Int(index)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.scrollViewDidEndScrollingAnimation(scrollView)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 320
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.00001
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch self.titleSegment.selectedSegmentIndex {
    case 0:
      let detail = ZDNiceSpecialDetailViewController(datasource:self.hotRecommendData[indexPath.item].dictionaryValue)
      self.navigationController!.pushViewController(detail, animated: true)
      
    case 1:
      let detail = ZDNiceSpecialDetailViewController(datasource:self.recentRecommendData[indexPath.item].dictionaryValue)
      self.navigationController!.pushViewController(detail, animated: true)
      
    default:
      break
    }
  }
}


// MARK: - UITableViewDataSource
extension ZDNiceSpecialViewController: UITableViewDataSource {
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "ZDSpecialTableViewCell", for: indexPath) as! ZDSpecialTableViewCell
    var json = JSON.init(nilLiteral: ())
    if tableView == self.hotTableView {
      json = self.hotRecommendData[indexPath.section]
    }
    if tableView == self.recentTableView {
      json = self.recentRecommendData[indexPath.section]
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
