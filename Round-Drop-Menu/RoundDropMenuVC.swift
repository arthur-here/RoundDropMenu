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
    
    @IBOutlet var menuView: RoundDropMenuView!
    @IBOutlet weak var dataImageView: UIImageView?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    var drops = [DropProtocol]()
    var dropViews = [DropView]()
    
    // MARK: Drop Appearence Properties
    
    var dropColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 130.0/255.0, alpha: 1.0)
    var backgroundDropColor = UIColor(red: 164.0/255.0, green: 25.0/255.0, blue: 118.0/255.0, alpha: 1.0)
    let maxDropRadius: CGFloat = 40.0
    let minDropRadius: CGFloat = 20.0
    var dropWidthWithOffset: CGFloat { return (maxDropRadius * 2 + 20) }
    
    // MARK: Drops Managing
    
    var selectedDropIndex: Int? {
        didSet {
            if let dropView = selectedDropView {
                if (oldValue != nil) && (dropViews[oldValue!] !== nil) {
                    dropViews[oldValue!].color = backgroundDropColor
                }
                dropView.color = dropColor
            }
        }
    }
    var selectedDrop: DropProtocol? {
        if let index = selectedDropIndex {
            return drops[index]
        } else {
            return nil
        }
    }
    var selectedDropView: DropView? {
        if let index = selectedDropIndex {
            return dropViews[index]
        } else {
            return nil
        }
    }
    
    var dropsScrollPosition: CGFloat = 0.0 {
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
    var maxDropsScrollPosition: CGFloat { return drops.isEmpty ? 0 : CGFloat(drops.count - 1) * dropWidthWithOffset }
    
    var menuCenter: CGPoint!
    var outlineRadius: CGFloat!
    
    // Here you can add your drops
    
    func setup() {
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("dropsScroll:"))
        menuView.addGestureRecognizer(panGesture)
        
        let d1 = Drop(title: "Arnold", description: "")
        let d2 = Drop(title: "Helga", description: "")
        let d3 = Drop(title: "Grandpa", description: "")
        addDrops([d1, d2, d3])
        
        updateView()
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
    
    func addDrops(newDrops: [DropProtocol]) {
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
    
    func updateView() {
        if let label = self.descriptionLabel {
            label.text = selectedDrop?.description
        }
        if let imageView = self.dataImageView {
            imageView.image = selectedDrop?.image
        }
    }
    
    // MARK: - Drops Animations
    
    func translateSelectedDropToCenter() {
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
    
    func moveDropsWithOffset(offset: CGFloat) {
        for dropView in self.dropViews {
            dropView.center.x += offset
            
            if !(dropView.center.x > menuView.frame.width + maxDropRadius || dropView.center.x < -maxDropRadius) {
                dropView.center.y = getYOnCircleForX(dropView.center.x)
                resizeDropView(dropView)
            }
        }
    }
    
    func getYOnCircleForX(x: CGFloat) -> CGFloat {
        func sqr(x: CGFloat) -> CGFloat { return x * x }
        // (x-menuCenter.x)^2 + (y-(dropRadius + outlineRadius))^2=outlineRadius^2
        return -sqrt(sqr(outlineRadius) - sqr(x - menuCenter.x)) + maxDropRadius + outlineRadius
    }
    
    func resizeDropView(dropView: DropView) {
        let offsetRelativeToCenter = abs(dropView.center.x - menuCenter.x)
        let scaleValue = 1 - offsetRelativeToCenter / menuCenter.x
        let dropScale = 2 * ((maxDropRadius - minDropRadius) * scaleValue + minDropRadius)
        
        let dropCenter = dropView.center
        dropView.frame = CGRect(x: dropCenter.x - dropScale/2, y: dropCenter.y - dropScale/2, width: dropScale, height: dropScale)
    }
    
    // MARK: - UIGestures
    
    var panStart: CGFloat = 0.0
    func dropsScroll(gestureRecognizer: UIPanGestureRecognizer) {
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
            updateView()
        }
    }
}




