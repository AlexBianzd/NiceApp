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
  
  init(datasource : Dictionary<String,JSON>) {
    super.init(nibName: nil, bundle: nil)
    self.datasource = datasource
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.green
    self.navigationController?.navigationBar.isHidden = true
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
}
