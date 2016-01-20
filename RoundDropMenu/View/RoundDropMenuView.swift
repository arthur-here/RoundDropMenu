//
//  RoundDropMenuView.swift
//  Round-Drop Menu
//
//  Created by Arthur Myronenko on 15.03.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

@IBDesignable
class RoundDropMenuView: UIView {
  @IBInspectable
  var color: UIColor = UIColor(red: 254/255, green: 225/255, blue: 22/255, alpha: 1.0)
  @IBInspectable
  var offset: CGFloat = 80
  
  override func drawRect(rect: CGRect) {
    let ovalRect = CGRect(x: rect.origin.x, y: rect.origin.y + 20, width: rect.width, height: rect.height * 2)
    let ovalPath = UIBezierPath(ovalInRect: CGRectInset(ovalRect, 20, offset))
    ovalPath.addClip()
    
    color.setFill()
    UIRectFill(bounds)
    
    super.drawRect(rect)
  }
}
