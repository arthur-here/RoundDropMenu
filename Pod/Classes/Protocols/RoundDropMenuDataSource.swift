//
//  RoundDropMenuDataSource.swift
//  Round-Drop-Menu
//
//  Created by Arthur Myronenko on 1/21/16.
//  Copyright © 2016 Arthur Myronenko. All rights reserved.
//

import Foundation

/**
 *  The `RoundDropMenuDataSource` is adopted by an object that mediates the application's
 *  data model for a `RoundDropMenu` object.
 */
public protocol RoundDropMenuDataSource {
  
  /**
   Asks the data source to return the number of dropViews in the menu.
   
   - parameter menu: An object representing the `RoundDropMenu` requesting the information.
   
   - returns: The number of dropViews in the menu.
   */
  func numberOfDropsInRoundDropMenu(menu: RoundDropMenu) -> Int
  
  /**
   Asks the data source for a `DropView` to insert into particular index in `RoundDropMenu`
   
   - parameter menu:  An object representing the `RoundDropMenu` requesting the information.
   - parameter index: An index locating `DropView` in `menu`.

   - returns: `DropView` object that `menu` can use for the specified `index`.
   */
  func roundDropMenu(menu: RoundDropMenu, dropViewForIndex index: Int) -> DropView
}
