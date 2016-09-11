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
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.delegate = self
            interactivePopGestureRecognizer?.delegate = self
            delegate = self
        }
        
        self.setupUI()
    }
    
    func setupUI() {
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Compact)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.layer.masksToBounds = true
    }
    
    func showMenu() {
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_SHOWMENU, object: nil)
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 0 {
            let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(showMenu))
            viewController.navigationItem.leftBarButtonItem = leftItem
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}
