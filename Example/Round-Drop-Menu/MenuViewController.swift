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
  
  var data = [
    (title: "Arnold", description: ""),
    (title: "Helga", description: ""),
    (title: "Grandpa", description: "")
  ]
  
  override func viewDidLoad() {
    menuView.dataSource = self
    super.viewDidLoad()
  }
  
  func numberOfDropsInRoundDropMenu(menu: RoundDropMenuView) -> Int {
    return data.count
  }
  
  func roundDropMenu(menu: RoundDropMenuView, dropViewForIndex index: Int) -> DropView {
    let dropView = DropView(color: UIColor.yellowColor())
    dropView.label.text = data[index].title
    return dropView
  }
  
  func didSelectDropWithIndex(index: Int) {
    // handle event
  }
}
