//
//  RoundDropMenuDataSource.swift
//  Round-Drop-Menu
//
//  Created by Arthur Myronenko on 1/21/16.
//  Copyright © 2016 Arthur Myronenko. All rights reserved.
//

import Foundation

protocol RoundDropMenuDataSource {
  func numberOfDropsInRoundDropMenu(menu: RoundDropMenuView) -> Int
  
  func roundDropMenu(menu: RoundDropMenuView, dropViewForIndex index: Int) -> DropView
}
