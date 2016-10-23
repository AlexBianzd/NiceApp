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
  @IBOutlet weak fileprivate var menuTableView: UITableView!
  @IBOutlet weak fileprivate var portraitView: UIImageView!
  @IBOutlet weak fileprivate var bottomCenterButton: UIButton!
  @IBAction fileprivate func bottomCenterButtonClick(_ sender: AnyObject) {
    let url = self.datasource["about_config"]!["item_on_sidebar"]["detail"].stringValue
    UIApplication.shared.openURL(URL.init(string: url)! as URL)
  }
  
  
  fileprivate var datasource = [String:JSON]()
  
  fileprivate var menuIcons = ["menu_icon_apps", "menu_icon_free", "menu_icon_discover", "menu_icon_article", "menu_icon_beauty"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UI_COLOR_DEFAULT
    
    self.setupUI()
    self.fetchDataSource()
  }
  
  fileprivate func setupUI() {
    
    menuTableView.backgroundColor = UIColor.clear
    menuTableView.tableFooterView = UIView()
    
    portraitView.layer.cornerRadius = 30
    portraitView.clipsToBounds = true
  }
  
  fileprivate func fetchDataSource() {
    let baseUrl = ZDAPIConfig.API_Server + "config"
    let parameters = ZDAPIConfig.API_Parameters
    Alamofire.request(baseUrl, method: .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
      switch response.result {
      case .success:
        let json = JSON(response.result.value!)
        self.datasource = json["data"].dictionaryValue
        self.menuTableView.reloadData()
        self.bottomCenterButton.setTitle(self.datasource["about_config"]!["item_on_sidebar"]["title"].stringValue, for: UIControlState.normal)
        self.menuTableView.selectRow(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .none)
      case .failure(let error):
        
        print(error)
      }
    }
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
  
  
}

// MARK: - UITableViewDelegate

extension ZDMenuViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! ZDMenuTableViewCell
    cell.dotView.isHidden = false
    
    if cell.titleLabel.text == "美一下我" {
      UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8")! as URL)
      return
    }
    
    NotificationCenter.default.post(name: NotifyCenter, object: datasource["side_menu"]!["menu_list"][indexPath.row]["verbose_name"].stringValue)
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! ZDMenuTableViewCell
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
    cell.backgroundColor = UIColor.clear
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.dotView.isHidden = !(datasource["side_menu"]!["menu_list"][indexPath.row]["default_open"].boolValue)
    if (datasource["side_menu"]!["menu_list"][indexPath.row]["default_open"].boolValue) {
      (DispatchQueue.main).async(execute: {
        NotificationCenter.default.post(name: NotifyShowMenu, object: nil)
      })
    }
    cell.iconView.image = UIImage.init(named: menuIcons[indexPath.row])
    cell.titleLabel.text = datasource["side_menu"]!["menu_list"][indexPath.row]["verbose_name"].stringValue
    return cell
  }
}


