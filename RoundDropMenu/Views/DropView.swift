//
//  DropView.swift
//  Round-Drop Menu
//
//  Created by Arthur Myronenko on 15.03.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

/// The `DropView` class defines the attributes of views that appear in `RoundDropMenu` objects.
class DropView: UIView {
  
  /// A Boolean value that indicates whether the cell is highlithed.
  /// If you change this property view's color will change to `color` `highlitedColor` property.
  var highlited = false { didSet { setNeedsDisplay() } }
  
  /// Default color of view.
  var color: UIColor { didSet { setNeedsDisplay() } }
  /// Color of view in `highlithed` state.
  var highlitedColor: UIColor? { didSet { setNeedsDisplay() } }
  
  /// Returns the label used for main textual content of the view.
  var label: UILabel

  /**
   Designated initializer used to create new `DropView` object. Shouldn't be used by anybody.
   
   - parameter color:    Default background `UIColor` of the view.
   - parameter radius:   Radius of the view.
   - parameter position: Origin position of the view.
   */
  private init(color: UIColor, radius: CGFloat, position: CGPoint) {
    self.color = color
    let frame = CGRect(x: position.x, y: position.y, width: radius * 2, height: radius * 2)
    self.label = UILabel()
    super.init(frame:frame)
    setup()
  }
  
  /**
   Convenience initializer used by `RoundDropDataSource`.
   
   - parameter color: Default background `UIColor` of the view.

   */
  convenience init(color: UIColor) {
    self.init(color: color, radius: 0.0, position: CGPoint.zero)
  }
  
  convenience override init(frame: CGRect) {
    self.init(color: UIColor.blueColor(), radius: 0.0, position: CGPoint.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /**
   Configures the object after initialization.
   */
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
