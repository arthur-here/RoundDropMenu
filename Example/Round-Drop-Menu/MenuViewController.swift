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
  
  let dropColor = UIColor(red: 164.0/255.0, green: 25.0/255.0, blue: 118.0/255.0, alpha: 1.0)
  
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
    let dropView = DropView(color: dropColor)
    dropView.highlitedColor = UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0)
    dropView.label.text = data[index].title
    return dropView
  }
  
  func didSelectDropWithIndex(index: Int) {
    // handle event
  }
}
