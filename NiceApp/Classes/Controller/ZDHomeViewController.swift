//
//  ZDHomeViewController.swift
//  NiceApp
//
//  Created by 边振东 on 8/7/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

enum ZDControllerType {
    case common
    case special
}

let NotifyShowMenu = Notification.Name(rawValue:"NotifyShowMenu")
let NotifyHideMenu = Notification.Name(rawValue:"NotifyHideMenu")
let NotifyColor    = Notification.Name(rawValue:"NotifyColor")
let NotifyCenter   = Notification.Name(rawValue:"NotifyCenter")

let UI_COLOR_DEFAULT : UIColor = UIColor(red: 0/255.0, green: 166/255.0, blue: 220/255.0, alpha: 1)


class ZDHomeViewController: UIViewController {
    fileprivate let menuWidth : CGFloat = 300
    fileprivate let animationDuration = 0.3
    
    fileprivate var centerNavController : ZDBaseNavigationController!
    fileprivate var commonController : ZDNiceCommonViewController?
    fileprivate var specialController : ZDNiceSpecialViewController?
    
    fileprivate var menuController : UIViewController!
    
    fileprivate weak var cover : UIView!
    
    fileprivate var currentController : UIViewController?
    
    var controllerType : ZDControllerType! = .common {
        willSet {
            self.controllerType = newValue
        }
        
        didSet {
            if controllerType == .common {
                guard !(self.currentController is ZDNiceCommonViewController) else {
                    self.leftMenuHiddenAnimate()
                    return
                }
                
                self.removeCenterNavController()
                if self.commonController == nil {
                    self.commonController = ZDNiceCommonViewController()
                }
                self.currentController = commonController
            } else if controllerType == .special {
                guard !(self.currentController is ZDNiceSpecialViewController) else {
                    self.leftMenuHiddenAnimate()
                    return
                }
                
                self.removeCenterNavController()
                if self.specialController == nil {
                    self.specialController = ZDNiceSpecialViewController()
                }
                self.currentController = specialController
            }
            self.centerNavController = ZDBaseNavigationController(rootViewController:self.currentController!)
            self .addCenterNavController()
            self.centerNavController!.view.frame.origin.x = self.menuWidth
            
            self.leftMenuHiddenAnimate()
        }
    }
    
    
    convenience init(centerNavController : ZDBaseNavigationController,
                     menuController : UIViewController) {
        
        self.init(nibName:nil,bundle:nil)
        self.centerNavController = centerNavController
        self.currentController = centerNavController.viewControllers.first
        self.menuController = menuController
        self.addmenuController()
        self.addCenterNavController()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UI_COLOR_DEFAULT
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZDHomeViewController.leftMenuShowAnimate), name: NotifyShowMenu, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZDHomeViewController.leftMenuHiddenAnimate), name: NotifyHideMenu, object: nil)
      
        NotificationCenter.default.addObserver(self, selector: #selector(ZDHomeViewController.leftMenuSetupBackColor(notify:)), name: NotifyColor, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZDHomeViewController.leftMenuSetupCenterView(notify:)), name: NotifyCenter, object: nil)
        
        self.view.bringSubview(toFront: self.centerNavController.view)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addCenterNavController () {
        self.currentController!.view.frame = self.view.frame
        self.view.addSubview(self.centerNavController!.view)
        self.addChildViewController(self.centerNavController!)
        self.addCover()
    }
    
    private func removeCenterNavController () {
        self.currentController!.removeFromParentViewController()
        self.centerNavController.view.removeFromSuperview()
        self.centerNavController.removeFromParentViewController()
        self.centerNavController = nil
    }
    
    private func addmenuController () {
      self.menuController.view.frame = CGRect.init(x: 0, y: 0, width: menuWidth, height: UIScreen.main.bounds.height)
        self.menuController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.view.addSubview(self.menuController.view)
        self.addChildViewController(self.menuController)
        
        let leftPan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ZDHomeViewController.leftMenuDidDrag(pan:)))
        self.menuController.view.addGestureRecognizer(leftPan)
    }
    
    private func addCover(){
        let cover : UIView = UIView(frame: centerNavController!.view.bounds)
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ZDHomeViewController.leftMenuDidDrag(pan:)))
        cover.backgroundColor = UIColor.clear
        cover.addGestureRecognizer(pan)
        self.cover = cover
        self.centerNavController!.view.addSubview(cover)
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ZDHomeViewController.leftMenuHiddenAnimate))
        cover.addGestureRecognizer(tap)
        
        self.centerNavController.view.bringSubview(toFront: cover)
        self.cover.isHidden = true
    }
    
    
    func leftMenuDidDrag(pan : UIPanGestureRecognizer) {
        let point = pan.translation(in: pan.view)
        
        if (pan.state == .cancelled || pan.state == .ended) {
            self.leftMenuHiddenAnimate()
        } else {
            self.centerNavController!.view.frame.origin.x += point.x
            pan.setTranslation(CGPoint.init(), in: self.centerNavController.view)
            if self.centerNavController!.view.frame.origin.x > menuWidth {
                self.centerNavController?.view.frame.origin.x = menuWidth
                self.cover.isHidden = false
            } else if self.centerNavController!.view.frame.origin.x <= 0 {
                self.centerNavController?.view.frame.origin.x = 0
                self.cover.isHidden = true
            }
        }
    }
    
    func leftMenuShowAnimate() {
        UIView.animate(withDuration: animationDuration, animations: { [unowned self]() -> Void in
            self.centerNavController!.view.frame.origin.x = self.menuWidth
            self.menuController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.cover.isHidden = false
            self.centerNavController.navigationBar.isHidden = true
            })
    }
    
    func leftMenuHiddenAnimate() {
        UIView.animate(withDuration: animationDuration, animations: { [unowned self]() -> Void in
            self.centerNavController!.view.frame.origin.x = 0
            self.cover.isHidden = true
            self.centerNavController.navigationBar.isHidden = false
        }) { (finish) -> Void in
            self.menuController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    func leftMenuSetupBackColor(notify : NSNotification) {
        let bg : String = notify.object as! String
        self.view.backgroundColor = UIColor.colorWithHexString(bg)
        self.commonController!.view.backgroundColor = UIColor.colorWithHexString(bg)
    }
    
    func leftMenuSetupCenterView(notify : NSNotification) {
        let controllerType : String = notify.object as! String
        switch controllerType {
        case "发现应用":
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                self.view.backgroundColor = UI_COLOR_DEFAULT
            })
            self.controllerType = .special
        default:
            self.controllerType = .common
        }
    }
}
