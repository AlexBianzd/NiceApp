//
//  ZDBaseNavigationController.swift
//  NiceApp
//
//  Created by 边振东 on 8/14/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDBaseNavigationController: UINavigationController,UINavigationControllerDelegate, UIGestureRecognizerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
    delegate = self    
    self.setupUI()
  }
  
    func setupUI() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.compact)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.layer.masksToBounds = true
    }
    
    func showMenu() {
        NotificationCenter.default.post(name: NotifyShowMenu, object: nil)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 0 {
            let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_menu")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMenu))
            viewController.navigationItem.leftBarButtonItem = leftItem
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}
