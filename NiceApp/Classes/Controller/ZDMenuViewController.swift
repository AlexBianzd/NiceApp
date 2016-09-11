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
        
        menuTableView.backgroundColor = UIColor.clearColor()
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
                self.menuTableView.selectRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
            case .Failure(let error):
                
                print(error)
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    
}

// MARK: - UITableViewDelegate

extension ZDMenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ZDMenuTableViewCell
        cell.dotView.hidden = false
        
        if cell.titleLabel.text == "美一下我" {
            UIApplication.sharedApplication().openURL(NSURL.init(string: "https://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8")!)
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_CENTERVIEW, object: datasource["side_menu"]!["menu_list"][indexPath.row]["verbose_name"].stringValue)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ZDMenuTableViewCell
        cell.dotView.hidden = true
    }
}

// MARK: - UITableViewDataSource

extension ZDMenuViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! ZDMenuTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.dotView.hidden = !(datasource["side_menu"]!["menu_list"][indexPath.row]["default_open"].boolValue)
        if (datasource["side_menu"]!["menu_list"][indexPath.row]["default_open"].boolValue) {
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_SHOWMENU, object: nil)
            })
        }
        cell.iconView.image = UIImage.init(named: menuIcons[indexPath.row])
        cell.titleLabel.text = datasource["side_menu"]!["menu_list"][indexPath.row]["verbose_name"].stringValue
        return cell
    }
}


