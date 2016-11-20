//
//  AppDelegate.swift
//  NiceApp
//
//  Created by 边振东 on 8/6/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var screenshotView: ZDScreenShotView!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    
    let menuStoryboard = UIStoryboard.init(name: "Menu", bundle: nil)
    let menuVc = menuStoryboard.instantiateViewController(withIdentifier: "MENU")
    window?.rootViewController = ZDHomeViewController.init(centerNavController: ZDBaseNavigationController(rootViewController:ZDNiceCommonViewController()), menuController: menuVc)
    
    screenshotView = ZDScreenShotView.init(frame: window!.bounds)
    window?.insertSubview(screenshotView, at: 0)
    window?.rootViewController?.view.addObserver(self, forKeyPath: "transform", options: .new, context: nil)
    
    return true
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    let value : NSValue = change?[.newKey] as! NSValue
    let newTransform : CGAffineTransform = value.cgAffineTransformValue
    screenshotView.showEffectChange(point: CGPoint.init(x: newTransform.tx, y: 0))
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

