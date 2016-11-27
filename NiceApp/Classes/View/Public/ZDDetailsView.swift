//
//  ZDDetailsView.swift
//  NiceApp
//
//  Created by 边振东 on 27/11/2016.
//  Copyright © 2016 边振东. All rights reserved.
//

import UIKit

class ZDDetailsView: UIView {
  var details: String!
		
  init(details : String) {
    super.init(frame:CGRect.init())
    self.details = details
    self.setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    
  }
}
