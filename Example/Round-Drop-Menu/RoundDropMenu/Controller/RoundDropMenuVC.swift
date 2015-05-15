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
           
            UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn,
                animations: { [unowned self] in self.moveDropsWithOffset(scrollOffset)
                    if let index = self.selectedDropIndex {
                        self.dropsScrollPosition = CGFloat(index) * self.dropWidthWithOffset
                    }
                }, completion: nil )
        }
    }
    
    private func moveDropsWithOffset(offset: CGFloat) {
        for dropView in self.dropViews {
            dropView.center.x += offset
            
            if !(dropView.center.x > menuView.frame.width + maxDropRadius || dropView.center.x < -maxDropRadius) {
                dropView.center.y = getYOnCircleForX(dropView.center.x)
                resizeDropView(dropView)
            }
        }
    }
    
    private func getYOnCircleForX(x: CGFloat) -> CGFloat {
        func sqr(x: CGFloat) -> CGFloat { return x * x }
        // (x-menuCenter.x)^2 + (y-(dropRadius + outlineRadius))^2=outlineRadius^2
        return -sqrt(sqr(outlineRadius) - sqr(x - menuCenter.x)) + maxDropRadius + outlineRadius
    }
    
    private func resizeDropView(dropView: DropView) {
        let offsetRelativeToCenter = abs(dropView.center.x - menuCenter.x)
        let scaleValue = 1 - offsetRelativeToCenter / menuCenter.x
        let dropScale = 2 * ((maxDropRadius - minDropRadius) * scaleValue + minDropRadius)
        
        let dropCenter = dropView.center
        dropView.frame = CGRect(x: dropCenter.x - dropScale/2, y: dropCenter.y - dropScale/2, width: dropScale, height: dropScale)
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




