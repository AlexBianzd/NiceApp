//
//  ZDMenuViewController.swift
//  NiceApp
//
//  Created by 边振东 on 8/7/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ZDMenuViewController: UIViewController {
  @IBOutlet weak private var menuTableView: UITableView!
  @IBOutlet weak private var portraitView: UIImageView!
  @IBOutlet weak private var bottomCenterButton: UIButton!
  @IBAction private func bottomCenterButtonClick(sender: AnyObject) {
    let url = self.datasource["about_config"]!["item_on_sidebar"]["detail"].stringValue
    UIApplication.sharedApplication().openURL(NSURL.init(string: url)!)
  }
  
  
  private var datasource = [String:JSON]()
  
  private var menuIcons = ["menu_icon_apps", "menu_icon_free", "menu_icon_discover", "menu_icon_article", "menu_icon_beauty"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UI_COLOR_DEFAULT
    
    self.setupUI()
    self.fetchDataSource()
  }
  
  private func setupUI() {
    
    menuTableView.backgroundColor = Color.clear
    menuTableView.tableFooterView = UIView()
    
    portraitView.layer.cornerRadius = 30
    portraitView.clipsToBounds = true
  }
  
  private func fetchDataSource() {
    let baseUrl = ZDAPIConfig.API_Server + "config"
    let parameters = ZDAPIConfig.API_Parameters
    Alamofire.request(.GET, baseUrl, parameters: parameters).responseJSON { response in
      switch response.result {
      case .Success:
        let json = JSON(response.result.value!)
        self.datasource = json["data"].dictionaryValue
        self.menuTableView.reloadData()
        self.bottomCenterButton.setTitle(self.datasource["about_config"]!["item_on_sidebar"]["title"].stringValue, forState: UIControlState.Normal)
        self.menuTableView.selectRowAtIndexPath(IndexPath.init(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
      case .Failure(let error):
        
        print(error)
      }
    }
  }
  
  // MARK: - Navigation
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  }
  
  
}

// MARK: - UITableViewDelegate

extension ZDMenuViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! ZDMenuTableViewCell
    cell.dotView.isHidden = false
    
    if cell.titleLabel.text == "美一下我" {
      UIApplication.shared.openURL(NSURL.init(string: "https://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8")! as URL)
      return
    }
    
    NotificationCenter.defaultCenter.postNotificationName(NotifyCenter, object: datasource["side_menu"]!["menu_list"][indexPath.row]["verbose_name"].stringValue)
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! ZDMenuTableViewCell
    cell.dotView.isHidden = true
  }
}

// MARK: - UITableViewDataSource

extension ZDMenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datasource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! ZDMenuTableViewCell
    cell.backgroundColor = Color.clear
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.dotView.hidden = !(datasource["side_menu"]!["menu_list"][indexPath.row]["default_open"].boolValue)
    if (datasource["side_menu"]!["menu_list"][indexPath.row]["default_open"].boolValue) {
      dispatch_async(DispatchQueue.main, {
        NotificationCenter.default.post(name: NotifyShowMenu, object: nil)
      })
    }
    cell.iconView.image = UIImage.init(named: menuIcons[indexPath.row])
    cell.titleLabel.text = datasource["side_menu"]!["menu_list"][indexPath.row]["verbose_name"].stringValue
    return cell
  }
}


