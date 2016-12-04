//
//  ZDBaseNavigationController.swift
//  NiceApp
//
//  Created by 边振东 on 8/14/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDBaseNavigationController: UINavigationController,UINavigationControllerDelegate, UIGestureRecognizerDelegate {
  
  var arrayScreenshot = Array<UIImage>.init()
  var panGesture: UIPanGestureRecognizer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.interactivePopGestureRecognizer?.isEnabled = false
    panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(ZDBaseNavigationController.panGestureBack(gesture:)))
    panGesture.delegate = self
    self.view.addGestureRecognizer(panGesture)
    self.setupUI()
  }
  
  func setupUI() {
    self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.isTranslucent = true
  }
  
  func showMenu() {
    NotificationCenter.default.post(name: NotifyShowMenu, object: nil)
  }
  
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    if self.viewControllers.count == 0 {
      let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_menu")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMenu))
      viewController.navigationItem.leftBarButtonItem = leftItem
      super.pushViewController(viewController, animated: animated)
      return
    } else if self.viewControllers.count >= 1 {
      viewController.hidesBottomBarWhenPushed = true
    }
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    UIGraphicsBeginImageContextWithOptions(CGSize.init(width: (kSCREEN_WIDTH), height: (kSCREEN_HEIGHT)), true, 0)
    appDelegate.window?.layer.render(in: UIGraphicsGetCurrentContext()!)
    let viewImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    arrayScreenshot.append(viewImage)
    appDelegate.screenshotView.imgView.image = viewImage
    super.pushViewController(viewController, animated: animated)
  }
  
  override func popViewController(animated: Bool) -> UIViewController? {
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    arrayScreenshot.removeLast()
    let image = arrayScreenshot.last
    if image != nil {
      appDelegate.screenshotView.imgView.image = image
    }
    return super.popViewController(animated: animated)
  }
  
  override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    let vcArr = super.popToViewController(viewController, animated: animated)
    if arrayScreenshot.count > (vcArr?.count)! {
      for _ in vcArr! {
        arrayScreenshot.removeLast()
      }
    }
    return vcArr
  }
  
  override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    if arrayScreenshot.count > 2 {
      arrayScreenshot.removeSubrange(1..<arrayScreenshot.endIndex)
    }
    arrayScreenshot.removeLast()
    let image = arrayScreenshot.last
    if image != nil {
      appDelegate.screenshotView.imgView.image = image
    }
    return super.popToRootViewController(animated: animated)
  }
  
// MARK: - back method
  func touchBack() {
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let rootVC = appDelegate.window?.rootViewController
    let presentedVC = rootVC?.presentedViewController
    appDelegate.screenshotView.isHidden = false
      rootVC?.view.transform = CGAffineTransform.init(translationX:  10, y: 0)
      presentedVC?.view.transform = CGAffineTransform.init(translationX:  10, y: 0)
    UIView.animate(withDuration: 0.3, animations: {
      rootVC?.view.transform = CGAffineTransform.init(translationX: kSCREEN_WIDTH, y: 0)
      presentedVC?.view.transform = CGAffineTransform.init(translationX: kSCREEN_WIDTH, y: 0)
    }, completion: { (finished : Bool) in
      if finished == true {
        self.popViewController(animated: false)
        rootVC?.view.transform = CGAffineTransform.identity;
        presentedVC?.view.transform =  CGAffineTransform.identity;
        appDelegate.screenshotView.isHidden = true;
      }
    })

  }
  
  func panGestureBack(gesture : UIPanGestureRecognizer) {
    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let rootVC = appDelegate.window?.rootViewController
    let presentedVC = rootVC?.presentedViewController
    if self.viewControllers.count == 1 {
      return
    }
    if gesture.state == .began {
      appDelegate.screenshotView.isHidden = false
    } else if gesture.state == .changed {
      let point_inView = gesture.translation(in: self.view)
      if point_inView.x >= 10 {
        rootVC?.view.transform = CGAffineTransform.init(translationX: point_inView.x - 10, y: 0)
        presentedVC?.view.transform = CGAffineTransform.init(translationX: point_inView.x - 10, y: 0)
      }
    } else if gesture.state == .ended {
      let point_inView = gesture.translation(in: self.view)
      if point_inView.x >= 80 {
        UIView.animate(withDuration: 0.3, animations: {
          rootVC?.view.transform = CGAffineTransform.init(translationX: 320, y: 0)
          presentedVC?.view.transform = CGAffineTransform.init(translationX: 320, y: 0)
        }, completion: { (finished : Bool) in
          if finished == true {
            self.popViewController(animated: false)
            rootVC?.view.transform = CGAffineTransform.identity;
            presentedVC?.view.transform =  CGAffineTransform.identity;
            appDelegate.screenshotView.isHidden = true;
          }
        })
      } else {
        UIView.animate(withDuration: 0.3, animations: {
          rootVC?.view.transform = CGAffineTransform.identity;
          presentedVC?.view.transform =  CGAffineTransform.identity;
        }, completion: { (finished : Bool) in
          appDelegate.screenshotView.isHidden = true;
        })
      }
    }
  }

  
// MARK: - Gesture
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer.isKind(of: NSClassFromString("UIPanGestureRecognizer")!) {
      let panGesture : UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
      if panGesture.view == self.view {
        let point_inView = panGesture.translation(in: self.view)
        let possible : Bool = point_inView.x != 0 && fabs(point_inView.y) == 0
        return possible
      }
    }
    return false
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) || otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) {
      return false
    }
    return true
  }
}
