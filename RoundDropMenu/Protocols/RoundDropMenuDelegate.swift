//
//  RoundDropMenuDelegate.swift
//  Round-Drop-Menu
//
//  Created by Arthur Myronenko on 15.05.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

/**
 *  The delegate of RoundDropMenu should conform to RoundDropMenuDelegate.
 */
protocol RoundDropMenuDelegate {
  
  /**
   Tells the delegate that the specified `DropView` is now selected.
   
   - parameter menu:  A `RoundDropMenu` object informing the delegate about
   the new `DropView` selection
   - parameter index: An index locating the new selected `DropView`
   */
  func roundDropMenu(menu: RoundDropMenu, didSelectDropWithIndex index: Int)
}
