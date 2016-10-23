//
//  UIViewController+ZD.swift
//  NiceApp
//
//  Created by 边振东 on 8/14/16.
//  Copyright © 2016 边振东. All rights reserved.
//

import Foundation

extension UIViewController {
    @IBAction func dismiss(_ segue : UIStoryboardSegue) {
        if (self.presentingViewController) != nil {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
