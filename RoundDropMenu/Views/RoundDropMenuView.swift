//
//  RoundDropMenuView.swift
//  Round-Drop Menu
//
//  Created by Arthur Myronenko on 15.03.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

class RoundDropMenuView: UIView {
  
  var dropViews = [DropView]()
  
  var delegate: RoundDropMenuDelegate!
  var dataSource: RoundDropMenuDataSource! {
    didSet {
      dropViews = loadDropViews()
      
      if selectedDropIndex == nil {
        selectedDropIndex = 0
      }
    }
  }
  
  // MARK: - Menu Appearance
  
  var color: UIColor = UIColor(red: 254/255, green: 225/255, blue: 22/255, alpha: 1.0)
  var offset: CGFloat = 80
  
  // MARK: Drop Appearance
  
  let maxDropRadius: CGFloat = 40.0
  let minDropRadius: CGFloat = 20.0
  var dropWidthWithOffset: CGFloat { return (maxDropRadius * 2 + 20) }
  
  private var selectedDropIndex: Int? {
    didSet {
      if let dropView = selectedDropView {
        if (oldValue != nil) && (dropViews[oldValue!] !== nil) {
          dropViews[oldValue!].highlited = false
        }
        dropView.highlited = true
      }
      delegate?.didSelectDropWithIndex(selectedDropIndex!)
    }
  }
  
  private var selectedDropView: DropView? {
    guard let index = selectedDropIndex else { return nil }
    return dropViews[index]
  }
  
  private var dropsScrollPosition: CGFloat = 0.0 {
    didSet {
      if dropsScrollPosition < 0.0 {
        dropsScrollPosition = 0.0
      } else if dropsScrollPosition > maxDropsScrollPosition {
        dropsScrollPosition = maxDropsScrollPosition
      }
      
      if dropsScrollPosition != oldValue {
        selectedDropIndex = Int(round(dropsScrollPosition / dropWidthWithOffset))
      }
    }
  }
  
  private var maxDropsScrollPosition: CGFloat {
    let dropsCount = dataSource.numberOfDropsInRoundDropMenu(self)
    return dropsCount == 0 ? 0 : CGFloat(dropsCount - 1) * dropWidthWithOffset
  }
  
  private var menuCenter: CGPoint!
  private var outlineRadius: CGFloat!
  
  private func dropViewForIndex(index: Int) -> DropView {
    guard let dataSource = dataSource else {
      fatalError("You should provide data source to RoundDropMenu")
    }
    guard index < dataSource.numberOfDropsInRoundDropMenu(self) else {
      fatalError("Index out of provided range!")
    }
    
    return dataSource.roundDropMenu(self, dropViewForIndex: index)
  }
  
  private func loadDropViews() -> [DropView] {
    var result = [DropView]()
    let dropsCount = dataSource.numberOfDropsInRoundDropMenu(self)
    for i in 0..<dropsCount {
      let dropView = dataSource.roundDropMenu(self, dropViewForIndex: i)
      dropView.frame.origin = CGPoint(x: CGFloat(i) * dropWidthWithOffset, y: 0)
      addSubview(dropView)
      result.append(dropView)
    }
    
    return result
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    let panGesture = UIPanGestureRecognizer(target: self, action: Selector("dropsScroll:"))
    addGestureRecognizer(panGesture)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    menuCenter = CGPoint(x: frame.size.width / 2, y: frame.height / 2)
    outlineRadius = frame.width / 2 + frame.width / 4
    
    translateSelectedDropToCenter()
  }
  
  // MARK: - Drops Animations
  
  private func translateSelectedDropToCenter() {
    if let centerDrop = selectedDropView {
      let scrollOffset = menuCenter.x - centerDrop.center.x
      
      moveDropsWithOffset(scrollOffset, animated: true)
      if let index = selectedDropIndex {
        self.dropsScrollPosition = CGFloat(index) * self.dropWidthWithOffset
      }
    }
  }
  
  func isDropInView(dropView: DropView) -> Bool {
    return !(dropView.center.x > frame.width + maxDropRadius || dropView.center.x < -maxDropRadius)
  }
  
  private func moveDropsWithOffset(offset: CGFloat, animated: Bool = false) {
    for dropView in self.dropViews {
      let newPosition = getDropPositionAfterApplyingOffset(dropView, offset: offset)
      
      if animated {
        animateDropMove(dropView, newPosition: newPosition)
      } else {
        dropView.center = newPosition
      }
      
      if isDropInView(dropView) {
        resizeDropView(dropView, animated: animated)
      }
    }
  }
  
  private func animateDropMove(dropView: DropView, newPosition: CGPoint) {
    let midPointX1 = dropView.center.x + (newPosition.x - dropView.center.x) / 3
    let midPoint1 = CGPoint(x: midPointX1, y: getYOnCircleForX(midPointX1))
    let midPointX2 = dropView.center.x + 2 * (newPosition.x - dropView.center.x) / 3
    let midPoint2 = CGPoint(x: midPointX2, y: getYOnCircleForX(midPointX2))
    
    let dropPath = UIBezierPath()
    dropPath.moveToPoint(dropView.center)
    dropPath.addCurveToPoint(newPosition, controlPoint1: midPoint1, controlPoint2: midPoint2)
    
    let midViewFrame1 = getDropViewFrame(dropView, position: midPoint1)
    let midViewFrame2 = getDropViewFrame(dropView, position: midPoint2)
    let endViewFrame = getDropViewFrame(dropView, position: newPosition)
    let midLabelPoint1 = CGPoint(
      x: midViewFrame1.width / 2,
      y: -1 - dropView.label.frame.height / 2)
    let midLabelPoint2 = CGPoint(
      x: midViewFrame2.width / 2,
      y: -1 - dropView.label.frame.height / 2)
    let endLabelPoint = CGPoint(
      x: endViewFrame.width / 2,
      y: -1 - dropView.label.frame.height / 2)
    
    let labelPath = UIBezierPath()
    labelPath.moveToPoint(
      CGPoint(x: dropView.frame.width / 2, y: -1 - dropView.label.frame.height / 2))
    labelPath.addCurveToPoint(endLabelPoint,
        controlPoint1: midLabelPoint1,
        controlPoint2: midLabelPoint2)
    
    // Constructing animation
    let animation = CAKeyframeAnimation(keyPath: "position")
    animation.path = dropPath.CGPath
    animation.removedOnCompletion = true
    animation.fillMode = kCAFillModeForwards
    animation.duration = 0.1
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    dropView.layer.addAnimation(animation, forKey: "moveToCenterAnimation")
    
    animation.path = labelPath.CGPath
    dropView.label.layer.addAnimation(animation, forKey: "label")
    
    dropView.center = newPosition
  }
  
  private func getDropPositionAfterApplyingOffset(dropView: DropView, offset: CGFloat) -> CGPoint {
    var result = dropView.center
    result.x += offset
    
    if isDropInView(dropView) {
      result.y = getYOnCircleForX(result.x)
    }
    return result
  }
  
  // swiftlint:disable variable_name_min_length
  private func getYOnCircleForX(x: CGFloat) -> CGFloat {
    func sqr(n: CGFloat) -> CGFloat { return n * n }
    // (x-menuCenter.x)^2 + (y-(dropRadius + outlineRadius))^2=outlineRadius^2
    if x <= menuCenter.x - outlineRadius || x >= menuCenter.x + outlineRadius {
      return maxDropRadius + outlineRadius
    }
    return -sqrt(sqr(outlineRadius) - sqr(x - menuCenter.x)) + maxDropRadius + outlineRadius
  }
  // swiftlint:enable variable_name_min_length
  
  private func resizeDropView(dropView: DropView, animated: Bool = false) {
    let newDropFrame = getDropViewFrame(dropView, position: dropView.center)
    if animated {
      animateDropResize(dropView, newSize: newDropFrame)
    } else {
      dropView.frame = newDropFrame
    }
  }
  
  private func getDropViewFrame(dropView: DropView, position: CGPoint) -> CGRect {
    let offsetRelativeToCenter = abs(position.x - menuCenter.x)
    let scaleValue = 1 - offsetRelativeToCenter / menuCenter.x
    let dropScale = 2 * ((maxDropRadius - minDropRadius) * scaleValue + minDropRadius)
    
    return CGRect(
      x: position.x - dropScale/2,
      y: position.y - dropScale/2,
      width: dropScale,
      height: dropScale)
  }
  
  private func animateDropResize(dropView: DropView, newSize: CGRect) {
    var s = newSize
    s.origin = CGPointZero
    let animation = CABasicAnimation(keyPath: "bounds")
    animation.fromValue = NSValue(&dropView.bounds, withObjCType: "CGRect")
    animation.toValue = NSValue(&s, withObjCType: "CGRect")
    animation.duration = 0.1
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    dropView.layer.addAnimation(animation, forKey: "resizeAnimation")
    dropView.frame = newSize
  }

  
  override func drawRect(rect: CGRect) {
    let ovalRect = CGRect(
      x: rect.origin.x,
      y: rect.origin.y + 20,
      width: rect.width,
      height: rect.height * 2)
    let ovalPath = UIBezierPath(ovalInRect: CGRectInset(ovalRect, 20, offset))
    ovalPath.addClip()
    
    color.setFill()
    UIRectFill(bounds)
    
    super.drawRect(rect)
  }
  
  // MARK: - UIGestures
  
  private var panStart: CGFloat = 0.0
  @objc private func dropsScroll(gestureRecognizer: UIPanGestureRecognizer) {
    if gestureRecognizer.state == .Began {
      panStart = gestureRecognizer.locationInView(self).x
    }
    
    if gestureRecognizer.state == UIGestureRecognizerState.Changed {
      let scrollOffset = (gestureRecognizer.locationInView(self).x - panStart) / 2
      panStart = gestureRecognizer.locationInView(self).x
      
      dropsScrollPosition -= scrollOffset
      moveDropsWithOffset(scrollOffset)
    }
    
    if gestureRecognizer.state == .Ended {
      translateSelectedDropToCenter()
    }
  }
}
