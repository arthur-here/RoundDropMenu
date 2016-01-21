//
//  RoundDropMenuView.swift
//  Round-Drop Menu
//
//  Created by Arthur Myronenko on 15.03.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

/// A `RoundDropMenu` displays list of items in form of circular views that are
/// scrolled by horizontal axis.
class RoundDropMenu: UIView {
  
  // MARK: - Delegate and Data Source
  
  /// The object that acts as the delegate of the menu.
  var delegate: RoundDropMenuDelegate!
  /// The object that acts as the data source of the menu.
  var dataSource: RoundDropMenuDataSource! { didSet { reloadData() } }
  
  // MARK: - Menu Appearance
  
  /// Color of oval in center of menu.
  var color: UIColor = UIColor(red: 1.0, green: 1.0, blue: 22.0/255.0, alpha: 1.0)
  /// Padding of the oval in center of menu.
  var offset: CGFloat = 80
  
  // MARK: Drop Appearance
  
  /// Radius of the drop in center of menu. Default is 40.0.
  let maxDropRadius: CGFloat = 40.0
  /// Radius of the drop on the edge of menu. Default is 20.0
  let minDropRadius: CGFloat = 20.0
  /// Radius that is used to calculate dropView's position and scale.
  private var outlineRadius: CGFloat! { return frame.width / 2 + frame.width / 4 }
  
  
  // MARK: - Menu Properties
  
  /// An array of `DropView` objects loaded from the data source.
  /// Should be changed only by `reloadData().`
  private var dropViews = [DropView]()
  
  /// Index of the currently selected drop. Can be nil only if there are no drops in menu.
  private var selectedDropIndex: Int? {
    didSet {
      if let dropView = selectedDropView {
        if (oldValue != nil) && (dropViews[oldValue!] !== nil) {
          dropViews[oldValue!].highlited = false
        }
        dropView.highlited = true
      }
      delegate?.roundDropMenu(self, didSelectDropWithIndex: selectedDropIndex!)
    }
  }
  
  /// Horizontal scroll position of menu.
  private var scrollPosition: CGFloat = 0.0 {
    didSet {
      if scrollPosition < 0.0 {
        scrollPosition = 0.0
      } else if scrollPosition > maxDropsScrollPosition {
        scrollPosition = maxDropsScrollPosition
      }
      
      if scrollPosition != oldValue {
        selectedDropIndex = Int(round(scrollPosition / dropWidthWithOffset))
      }
    }
  }
  
  // MARK: Computed Properties
  
  /// Maximum width of dropView with offset.
  private var dropWidthWithOffset: CGFloat { return (maxDropRadius * 2 + 20) }
  
  /// Maximum content width of the menu.
  private var maxDropsScrollPosition: CGFloat {
    let dropsCount = dataSource.numberOfDropsInRoundDropMenu(self)
    return dropsCount == 0 ? 0 : CGFloat(dropsCount - 1) * dropWidthWithOffset
  }
  
  /// Returns a `DropView` object that is currently selected in the menu.
  private var selectedDropView: DropView? {
    guard let index = selectedDropIndex else { return nil }
    return dropViews[index]
  }
  
  /// Stores location of pan gesture start.
  private var panStart: CGFloat = 0.0
}

// MARK: - View Lifecycle
extension RoundDropMenu {
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    let panGesture = UIPanGestureRecognizer(target: self, action: Selector("dropsScroll:"))
    addGestureRecognizer(panGesture)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    translateSelectedDropToCenter()
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
}

// MARK: - Managing Data
extension RoundDropMenu {
  /**
   Reloads all dropViews from data source.
   */
  func reloadData() {
    dropViews = []
    let dropsCount = dataSource.numberOfDropsInRoundDropMenu(self)
    for i in 0..<dropsCount {
      let dropView = dataSource.roundDropMenu(self, dropViewForIndex: i)
      dropView.frame.origin = CGPoint(x: CGFloat(i) * dropWidthWithOffset, y: 0)
      addSubview(dropView)
      dropViews.append(dropView)
    }
    
    if selectedDropIndex == nil || selectedDropIndex >= dropViews.count {
      selectedDropIndex = 0
    }
  }
}

// MARK: - DropViews Repositioning
extension RoundDropMenu {
  
  /**
   Translates all drops by provided x-axis offset.
   
   - parameter offset:   X-axis offset to move drops.
   - parameter animated: Boolean value that indicates if translating should be performed animated.
   */
  private func moveDropsWithOffset(offset: CGFloat, animated: Bool = false) {
    for dropView in self.dropViews {
      let newPosition = getDropPosition(dropView, afterApplyingOffset: offset)
      
      if animated {
        animateDropMove(dropView, newPosition: newPosition)
      } else {
        dropView.center = newPosition
      }
      
      if dropIsVisible(dropView) {
        resizeDropView(dropView, animated: animated)
      }
    }
  }
  
  /**
   Calculates offset needed to translate `selectedDropView` to the center
   of the menu and applies `moveDropsWithOffset(_:, animated:).`
   */
  private func translateSelectedDropToCenter() {
    if let centerDrop = selectedDropView {
      let scrollOffset = bounds.midX - centerDrop.center.x
      
      moveDropsWithOffset(scrollOffset, animated: true)
      if let index = selectedDropIndex {
        self.scrollPosition = CGFloat(index) * self.dropWidthWithOffset
      }
    }
  }
  
  /**
   Indicates if provided `dropView`'s bounds is in the menu's frame.
   
   - parameter dropView: `DropView` object to check.
   
   - returns: `true` if `dropView`'s frame located fully in the menu, `false` otherwise.
   */
  private func dropIsVisible(dropView: DropView) -> Bool {
    return !(dropView.center.x > frame.width + maxDropRadius || dropView.center.x < -maxDropRadius)
  }
  
  /**
   Animates `dropView`'s transition to new position.
   
   - parameter dropView:    `DropView` objects to move.
   - parameter newPosition: New position.
   */
  // swiftlint:disable function_body_length
  private func animateDropMove(dropView: DropView, newPosition: CGPoint) {
    let midPointX1 = dropView.center.x + (newPosition.x - dropView.center.x) / 3
    let midPoint1 = CGPoint(x: midPointX1, y: getYOnCircleForX(midPointX1))
    let midPointX2 = dropView.center.x + 2 * (newPosition.x - dropView.center.x) / 3
    let midPoint2 = CGPoint(x: midPointX2, y: getYOnCircleForX(midPointX2))
    
    let dropPath = UIBezierPath()
    dropPath.moveToPoint(dropView.center)
    dropPath.addCurveToPoint(newPosition, controlPoint1: midPoint1, controlPoint2: midPoint2)
    
    let midViewFrame1 = getDropViewFrameAtPosition(midPoint1)
    let midViewFrame2 = getDropViewFrameAtPosition(midPoint2)
    let endViewFrame = getDropViewFrameAtPosition(newPosition)
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
    
    let animation = CAKeyframeAnimation(keyPath: "position")
    animation.path = dropPath.CGPath
    animation.removedOnCompletion = true
    animation.fillMode = kCAFillModeForwards
    animation.duration = 0.1
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    dropView.layer.addAnimation(animation, forKey: nil)
    
    animation.path = labelPath.CGPath
    dropView.label.layer.addAnimation(animation, forKey: nil)
    
    dropView.center = newPosition
  }
  // swiftlint:enable function_body_length
  
  /**
   Calculates new position of `dropView` after translating translating it along x-axis by `offset`.
   
   - parameter dropView: `DropView` object to move.
   - parameter offset:   Offset by x-axis.
   
   - returns: New `dropView` position.
   */
  private func getDropPosition(dropView: DropView, afterApplyingOffset offset: CGFloat) -> CGPoint {
    var result = dropView.center
    result.x += offset
    
    if dropIsVisible(dropView) {
      result.y = getYOnCircleForX(result.x)
    }
    return result
  }
  
  /**
   Calculates y-coordinate based on provided x-coordinate, `outlineRadius` and `maxDropRadius`.
   
   - parameter xValue: Provided value of x-axis.
   
   - returns: y-coordinate.
   */
  private func getYOnCircleForX(xValue: CGFloat) -> CGFloat {
    func sqr(num: CGFloat) -> CGFloat { return num * num }
    // (x-menuCenter.x)^2 + (y-(dropRadius + outlineRadius))^2=outlineRadius^2
    if xValue <= bounds.midX - outlineRadius || xValue >= bounds.midX + outlineRadius {
      return maxDropRadius + outlineRadius
    }
    return -sqrt(sqr(outlineRadius) - sqr(xValue - bounds.midX)) + maxDropRadius + outlineRadius
  }
  
  /**
   Scales provided `dropView` accordingly to it's position.
   
   - parameter dropView: `DropView` object to scale.
   - parameter animated: Boolean value that indicates if scaling should be performed animated.
   */
  private func resizeDropView(dropView: DropView, animated: Bool = false) {
    let newDropFrame = getDropViewFrameAtPosition(dropView.center)
    if animated {
      animateDropResize(dropView, newSize: newDropFrame)
    } else {
      dropView.frame = newDropFrame
    }
  }
  
  /**
   Calculates frame for `DropView` object accordingly to provided `position`.
   
   - parameter position: `CGPoint` struct to calculate new frame.
   
   - returns: Frame for `DropView` object on `position`.
   */
  private func getDropViewFrameAtPosition(position: CGPoint) -> CGRect {
    let offsetRelativeToCenter = abs(position.x - bounds.midX)
    let scaleValue = 1 - offsetRelativeToCenter / bounds.midX
    let dropScale = 2 * ((maxDropRadius - minDropRadius) * scaleValue + minDropRadius)
    
    return CGRect(
      x: position.x - dropScale/2,
      y: position.y - dropScale/2,
      width: dropScale,
      height: dropScale)
  }
  
  /**
   Animate provided `dropView`'s layer resizing to `newSize`.
   
   - parameter dropView: `DropView` object to resize.
   - parameter newSize:  Needed size.
   */
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
}

// MARK: - Gestures
extension RoundDropMenu {
  @objc private func dropsScroll(gestureRecognizer: UIPanGestureRecognizer) {
    if gestureRecognizer.state == .Began {
      panStart = gestureRecognizer.locationInView(self).x
    }
    
    if gestureRecognizer.state == UIGestureRecognizerState.Changed {
      let scrollOffset = (gestureRecognizer.locationInView(self).x - panStart) / 2
      panStart = gestureRecognizer.locationInView(self).x
      
      scrollPosition -= scrollOffset
      moveDropsWithOffset(scrollOffset)
    }
    
    if gestureRecognizer.state == .Ended {
      translateSelectedDropToCenter()
    }
  }
}
