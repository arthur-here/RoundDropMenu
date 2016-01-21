//
//  DropView.swift
//  Round-Drop Menu
//
//  Created by Arthur Myronenko on 15.03.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

class DropView: UIView {
  
  var highlited = false { didSet { setNeedsDisplay() } }
  
  var color: UIColor { didSet { setNeedsDisplay() } }
  var highlitedColor: UIColor? { didSet { setNeedsDisplay() } }
  
  var label: UILabel
  
  init(color: UIColor, radius: CGFloat, position: CGPoint) {
    self.color = color
    let frame = CGRect(x: position.x, y: position.y, width: radius * 2, height: radius * 2)
    self.label = UILabel()
    super.init(frame:frame)
    setup()
  }
  
  convenience init(color: UIColor) {
    self.init(color: color, radius: 0.0, position: CGPoint.zero)
  }
  
  convenience override init(frame: CGRect) {
    self.init(color: UIColor.blueColor(), radius: 0.0, position: CGPoint.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    label.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(label)
    let labelConstraintV = NSLayoutConstraint
      .constraintsWithVisualFormat("V:[label]-(1)-[superview]",
      options: NSLayoutFormatOptions.AlignAllCenterX,
      metrics: nil,
      views: ["superview": self, "label": label])
    self.addConstraints(labelConstraintV)
    
    label.textAlignment = .Center
    label.font = UIFont.boldSystemFontOfSize(17.0)
    label.textColor = UIColor.blackColor()
    self.opaque = false
  }
  
  override func drawRect(rect: CGRect) {
    let ovalPath = UIBezierPath(ovalInRect: rect)
    ovalPath.addClip()
    
    if highlited, let highlitedColor = highlitedColor {
      highlitedColor.setFill()
    } else {
      color.setFill()
    }
    
    UIRectFill(bounds)
    
    super.drawRect(rect)
  }
}
