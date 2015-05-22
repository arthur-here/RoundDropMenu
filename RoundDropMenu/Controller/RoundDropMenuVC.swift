//
//  RoundDropMenuViewController.swift
//  Round-Drop Menu
//
//  Created by Arthur Myronenko on 15.03.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

class RoundDropMenuViewController: UIViewController {
    
    // MARK: - Properties
    
    private var menuView: RoundDropMenuView! { return viewForMenu() }
    
    var delegate: RoundDropMenuDelegate?
    
    private var drops = [DropProtocol]()
    private var dropViews = [DropView]()
    
    // MARK: Drop Appearence Properties
    
    var dropColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 130.0/255.0, alpha: 1.0)
    var backgroundDropColor = UIColor(red: 164.0/255.0, green: 25.0/255.0, blue: 118.0/255.0, alpha: 1.0)
    let maxDropRadius: CGFloat = 40.0
    let minDropRadius: CGFloat = 20.0
    var dropWidthWithOffset: CGFloat { return (maxDropRadius * 2 + 20) }
    
    // MARK: Drops Managing
    
    private var selectedDropIndex: Int? {
        didSet {
            if let dropView = selectedDropView {
                if (oldValue != nil) && (dropViews[oldValue!] !== nil) {
                    dropViews[oldValue!].color = backgroundDropColor
                }
                dropView.color = dropColor
            }
            delegate?.didSelectDropWithIndex(selectedDropIndex!)
        }
    }
    private var selectedDrop: DropProtocol? {
        if let index = selectedDropIndex {
            return drops[index]
        } else {
            return nil
        }
    }
    private var selectedDropView: DropView? {
        if let index = selectedDropIndex {
            return dropViews[index]
        } else {
            return nil
        }
    }
    
    private var dropsScrollPosition: CGFloat = 0.0 {
        didSet {
            if dropsScrollPosition < 0.0 {
                dropsScrollPosition = 0.0
            } else if dropsScrollPosition > maxDropsScrollPosition {
                dropsScrollPosition = maxDropsScrollPosition;
            }
            if (dropsScrollPosition != oldValue) {
                selectedDropIndex = Int(round(dropsScrollPosition / dropWidthWithOffset))
            }
        }
    }
    private var maxDropsScrollPosition: CGFloat { return drops.isEmpty ? 0 : CGFloat(drops.count - 1) * dropWidthWithOffset }
    
    private var menuCenter: CGPoint!
    private var outlineRadius: CGFloat!
    
    private func setup() {
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("dropsScroll:"))
        menuView.addGestureRecognizer(panGesture)
        
        let number = numberOfDrops()
        for i in 0..<number {
            if let drop = dropForIndex(i) {
                addDrops([drop])
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        setup()
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        menuCenter = CGPoint(x: menuView.frame.size.width / 2, y: menuView.frame.height / 2)
        outlineRadius = menuView.frame.width / 2 + menuView.frame.width / 4
        
        translateSelectedDropToCenter()
    }
    
    private func addDrops(newDrops: [DropProtocol]) {
        for newDrop in newDrops {
            let newDropView = DropView(color: backgroundDropColor,
                radius: maxDropRadius,
                position: CGPointMake(CGFloat(dropViews.count) * dropWidthWithOffset, 0))
            newDropView.label.text = newDrop.title
            dropViews += [newDropView]
            self.menuView.addSubview(newDropView)
        }
        drops += newDrops
        
        if selectedDropIndex == nil {
            selectedDropIndex = 0
        }
    }
    
    // MARK: - RoundDropMenuDataSource
    
    func numberOfDrops() -> Int {
        return drops.count
    }
    
    func dropForIndex(index: Int) -> DropProtocol? {
        return (drops.count > 0) ? drops[index] : nil
    }
    
    func viewForMenu() -> RoundDropMenuView? {
        assert(true, "Needs to be overriden in a subclass")
        return nil;
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
        return !(dropView.center.x > menuView.frame.width + maxDropRadius || dropView.center.x < -maxDropRadius)
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
        // Constructing path
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
        let midLabelPoint1 = CGPoint(x: midViewFrame1.width / 2, y: -1 - dropView.label.frame.height / 2)
        let midLabelPoint2 = CGPoint(x: midViewFrame2.width / 2, y: -1 - dropView.label.frame.height / 2)
        let endLabelPoint = CGPoint(x: endViewFrame.width / 2, y: -1 - dropView.label.frame.height / 2)
        
        let labelPath = UIBezierPath()
        labelPath.moveToPoint(CGPoint(x: dropView.frame.width / 2, y: -1 - dropView.label.frame.height / 2))
        labelPath.addCurveToPoint(endLabelPoint, controlPoint1: midLabelPoint1, controlPoint2: midLabelPoint2)
        
        
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
    
    private func getYOnCircleForX(x: CGFloat) -> CGFloat {
        func sqr(x: CGFloat) -> CGFloat { return x * x }
        // (x-menuCenter.x)^2 + (y-(dropRadius + outlineRadius))^2=outlineRadius^2
        return -sqrt(sqr(outlineRadius) - sqr(x - menuCenter.x)) + maxDropRadius + outlineRadius
    }
    
    private func resizeDropView(dropView: DropView, animated: Bool = false) {
        let newDropFrame = getDropViewFrame(dropView, position: dropView.center)
        if (animated) {
            animateDropResize(dropView, newSize: newDropFrame)
        } else {
            dropView.frame = newDropFrame
        }
    }
    
    private func getDropViewFrame(dropView: DropView, position: CGPoint) -> CGRect {
        let offsetRelativeToCenter = abs(position.x - menuCenter.x)
        let scaleValue = 1 - offsetRelativeToCenter / menuCenter.x
        let dropScale = 2 * ((maxDropRadius - minDropRadius) * scaleValue + minDropRadius)
        
        return CGRect(x: position.x - dropScale/2, y: position.y - dropScale/2, width: dropScale, height: dropScale)
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
    
    // MARK: - UIGestures
    
    private var panStart: CGFloat = 0.0
    @objc private func dropsScroll(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            panStart = gestureRecognizer.locationInView(menuView).x
        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            let scrollOffset = (gestureRecognizer.locationInView(menuView).x - panStart) / 2
            panStart = gestureRecognizer.locationInView(menuView).x
            
            dropsScrollPosition -= scrollOffset
            moveDropsWithOffset(scrollOffset)
        }
        
        if gestureRecognizer.state == .Ended {
            translateSelectedDropToCenter()
        }
    }
}




