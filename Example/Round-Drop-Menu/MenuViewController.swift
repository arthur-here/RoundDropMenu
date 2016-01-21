//
//  MenuViewController.swift
//  Round-Drop-Menu
//
//  Created by Arthur Myronenko on 15.05.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, RoundDropMenuDataSource, RoundDropMenuDelegate {
  
  @IBOutlet weak var menuView: RoundDropMenuView!
  
  var data = [Drop(title: "Arnold", description: ""),
    Drop(title: "Helga", description: ""),
    Drop(title: "Grandpa", description: "")]
  
  override func viewDidLoad() {
    menuView.dataSource = self
    super.viewDidLoad()
  }
  
  func numberOfDropsInRoundDropMenu(menu: RoundDropMenuView) -> Int {
    return data.count
  }
  
  func roundDropMenu(menu: RoundDropMenuView, dropViewForIndex index: Int) -> DropView {
    let dropView = DropView(color: UIColor.yellowColor())
    return dropView
  }
  
  func didSelectDropWithIndex(index: Int) {
    // handle event
  }
}
