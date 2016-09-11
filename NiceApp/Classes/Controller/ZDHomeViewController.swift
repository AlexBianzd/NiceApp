//
//  ZDHomeViewController.swift
//  NiceApp
//
//  Created by 边振东 on 8/7/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

enum ZDControllerType {
    case Common
    case Special
}

let NOTIFY_SHOWMENU   : String = "NOTIFY_SHOWMENU"
let NOTIFY_HIDEMENU   : String = "NOTIFY_HIDEMENU"
let NOTIFY_COLOR      : String = "NOTIFY_COLOR"
let NOTIFY_CENTERVIEW : String = "NOTIFY_CENTERVIEW"

let UI_COLOR_DEFAULT : UIColor = UIColor(red: 0/255.0, green: 166/255.0, blue: 220/255.0, alpha: 1)


class ZDHomeViewController: UIViewController {
    private let menuWidth : CGFloat = 300
    private let animationDuration = 0.3
    
    private var centerNavController : ZDBaseNavigationController!
    private var commonController : ZDNiceCommonViewController?
    private var specialController : ZDNiceSpecialViewController?
    
    private var menuController : UIViewController!
    
    private weak var cover : UIView!
    
    private var currentController : UIViewController?
    
    var controllerType : ZDControllerType! = .Common {
        willSet {
            self.controllerType = newValue
        }
        
        didSet {
            if controllerType == .Common {
                guard !(self.currentController is ZDNiceCommonViewController) else {
                    self.leftMenuHiddenAnimate()
                    return
                }
                
                self.removeCenterNavController()
                if self.commonController == nil {
                    self.commonController = ZDNiceCommonViewController()
                }
                self.currentController = commonController
            } else if controllerType == .Special {
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZDHomeViewController.leftMenuShowAnimate), name: NOTIFY_SHOWMENU, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZDHomeViewController.leftMenuHiddenAnimate), name: NOTIFY_HIDEMENU, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZDHomeViewController.leftMenuSetupBackColor(_:)), name: NOTIFY_COLOR, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZDHomeViewController.leftMenuSetupCenterView(_:)), name: NOTIFY_CENTERVIEW, object: nil)
        
        self.view.bringSubviewToFront(self.centerNavController.view)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        self.menuController.view.frame = CGRectMake(0, 0, menuWidth, UIScreen.mainScreen().bounds.height)
        self.menuController.view.transform = CGAffineTransformMakeScale(0.5, 0.5)
        self.view.addSubview(self.menuController.view)
        self.addChildViewController(self.menuController)
        
        let leftPan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ZDHomeViewController.leftMenuDidDrag(_:)))
        self.menuController.view.addGestureRecognizer(leftPan)
    }
    
    private func addCover(){
        let cover : UIView = UIView(frame: centerNavController!.view.bounds)
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ZDHomeViewController.leftMenuDidDrag(_:)))
        cover.backgroundColor = UIColor.clearColor()
        cover.addGestureRecognizer(pan)
        self.cover = cover
        self.centerNavController!.view.addSubview(cover)
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ZDHomeViewController.leftMenuHiddenAnimate))
        cover.addGestureRecognizer(tap)
        
        self.centerNavController.view.bringSubviewToFront(cover)
        self.cover.hidden = true
    }
    
    
    func leftMenuDidDrag(pan : UIPanGestureRecognizer) {
        let point = pan.translationInView(pan.view)
        
        if (pan.state == .Cancelled || pan.state == .Ended) {
            self.leftMenuHiddenAnimate()
        } else {
            self.centerNavController!.view.frame.origin.x += point.x
            pan.setTranslation(CGPointZero, inView: self.centerNavController.view)
            if self.centerNavController!.view.frame.origin.x > menuWidth {
                self.centerNavController?.view.frame.origin.x = menuWidth
                self.cover.hidden = false
            } else if self.centerNavController!.view.frame.origin.x <= 0 {
                self.centerNavController?.view.frame.origin.x = 0
                self.cover.hidden = true
            }
        }
    }
    
    func leftMenuShowAnimate() {
        UIView.animateWithDuration(animationDuration, animations: { [unowned self]() -> Void in
            self.centerNavController!.view.frame.origin.x = self.menuWidth
            self.menuController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.cover.hidden = false
            self.centerNavController.navigationBar.hidden = true
            })
    }
    
    func leftMenuHiddenAnimate() {
        UIView.animateWithDuration(animationDuration, animations: { [unowned self]() -> Void in
            self.centerNavController!.view.frame.origin.x = 0
            self.cover.hidden = true
            self.centerNavController.navigationBar.hidden = false
        }) { (finish) -> Void in
            self.menuController.view.transform = CGAffineTransformMakeScale(0.5, 0.5)
        }
    }
    
    func leftMenuSetupBackColor(notify : NSNotification) {
        let bg : String = notify.object as! String
        self.view.backgroundColor = UIColor.colorWithHexString(stringToConvert: bg)
        self.commonController!.view.backgroundColor = UIColor.colorWithHexString(stringToConvert: bg)
    }
    
    func leftMenuSetupCenterView(notify : NSNotification) {
        let controllerType : String = notify.object as! String
        switch controllerType {
        case "发现应用":
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                self.view.backgroundColor = UI_COLOR_DEFAULT
            })
            self.controllerType = .Special
        default:
            self.controllerType = .Common
        }
    }
}
