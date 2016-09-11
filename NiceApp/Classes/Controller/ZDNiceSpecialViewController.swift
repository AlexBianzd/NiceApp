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
    
    private var titleSegment: UISegmentedControl!
    private var containerScrollView: UIScrollView!
    private var hotTableView: UITableView!
    private var recentTableView: UITableView!
    
    private var hotRecommendData = [JSON]()
    private var recentRecommendData = [JSON]()
    
    private let defaultPageSize = 10
    private var hotPage = 1
    private var recentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UI_COLOR_DEFAULT
        
        self.setupUI()
        self.fetchHotRecommendData()
        self.fetchRecentRecommendData()
    }
    
    private func setupUI() {
        titleSegment = UISegmentedControl.init(items: ["最热分享", "最近分享"])
        titleSegment.setWidth(80, forSegmentAtIndex: 0)
        titleSegment.setWidth(80, forSegmentAtIndex: 1)
        titleSegment.tintColor = UIColor.whiteColor()
        titleSegment.selectedSegmentIndex = 0
        self.navigationItem.titleView = titleSegment
        titleSegment.addTarget(self, action:#selector(scrollToViewAtSegIndex), forControlEvents: UIControlEvents.ValueChanged)
        
        containerScrollView = UIScrollView.init(frame: self.view.bounds)
        containerScrollView.delegate = self
        containerScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0)
        containerScrollView.pagingEnabled = true
        containerScrollView.bounces = false
        containerScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(containerScrollView)
        containerScrollView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.right.bottom.equalTo(self.view)
        }
        
        hotTableView = UITableView.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64), style: .Grouped)
        hotTableView.delegate = self
        hotTableView.dataSource = self
        hotTableView.backgroundColor = UIColor.clearColor()
        hotTableView.separatorStyle = .None
        hotTableView.showsVerticalScrollIndicator = false
        hotTableView!.registerNib(UINib(nibName: "ZDSpecialTableViewCell", bundle: nil), forCellReuseIdentifier: "ZDSpecialTableViewCell")
        containerScrollView.addSubview(hotTableView)
        
        recentTableView = UITableView.init(frame: CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64), style: .Grouped)
        recentTableView.delegate = self
        recentTableView.dataSource = self
        recentTableView.backgroundColor = UIColor.clearColor()
        recentTableView.separatorStyle = .None
        recentTableView.showsVerticalScrollIndicator = false
        recentTableView!.registerNib(UINib(nibName: "ZDSpecialTableViewCell", bundle: nil), forCellReuseIdentifier: "ZDSpecialTableViewCell")
        containerScrollView.addSubview(recentTableView)
    }
    
    private func fetchHotRecommendData() {
        let baseHotUrl = ZDAPIConfig.API_Server + "community/recommend_apps"
        var parameters = ZDAPIConfig.API_Parameters
        parameters["page"] = String(hotPage)
        parameters["page_size"] = String(defaultPageSize)
        Alamofire.request(.GET, baseHotUrl, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                self.hotRecommendData = json["data"]["apps"].arrayValue
                self.hotTableView.reloadData()
            case .Failure(let error):
                print(error)
            }
            
        }
    }
    private func fetchRecentRecommendData() {
        let baseHotUrl = ZDAPIConfig.API_Server + "community/apps"
        var parameters = ZDAPIConfig.API_Parameters
        parameters["page"] = String(recentPage)
        parameters["page_size"] = String(defaultPageSize)
        Alamofire.request(.GET, baseHotUrl, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                self.recentRecommendData = json["data"]["apps"].arrayValue
                self.recentTableView.reloadData()
            case .Failure(let error):
                print(error)
            }
            
        }
    }
    
    func scrollToViewAtSegIndex() {
        let index = self.titleSegment.selectedSegmentIndex
        containerScrollView.setContentOffset(CGPointMake(self.view.bounds.size.width * CGFloat(index), containerScrollView.contentOffset.y), animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ZDNiceSpecialViewController: UITableViewDelegate {
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index = containerScrollView.contentOffset.x / containerScrollView.bounds.size.width
        titleSegment.selectedSegmentIndex = Int(index)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch self.titleSegment.selectedSegmentIndex {
        case 0:
            return self.hotRecommendData.count
        case 1:
            return self.recentRecommendData.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ZDSpecialTableViewCell", forIndexPath: indexPath) as! ZDSpecialTableViewCell
        var json = JSON.init(nilLiteral: ())
        if tableView == self.hotTableView {
            json = self.hotRecommendData[indexPath.section]
        }
        if tableView == self.recentTableView {
            json = self.recentRecommendData[indexPath.section]
        }
        
        cell.authorAvatar.kf_setImageWithURL(NSURL(string: json["author_avatar_url"].stringValue))
        cell.authorName.text = json["author_name"].stringValue
        cell.authorCareer.text = json["author_career"].stringValue
        cell.coverImage.kf_setImageWithURL(NSURL(string: json["cover_image"].stringValue))
        cell.iconImage.kf_setImageWithURL(NSURL(string: json["icon_image"].stringValue))
        cell.appName.text = json["app_name"].stringValue
        cell.appDescription.text = json["description"].stringValue
        cell.browse.text = json["show_times"].stringValue
        cell.flower.text = json["up_times"].stringValue
        cell.comment.text = json["comment_times"].stringValue
        return cell
    }
}
