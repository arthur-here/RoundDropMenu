//
//  MenuViewController.swift
//  Round-Drop-Menu
//
//  Created by Arthur Myronenko on 15.05.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

class MenuViewController: RoundDropMenuViewController, RoundDropMenuDelegate {
  
  @IBOutlet weak var menuView: RoundDropMenuView!
  
  var data = [Drop(title: "Arnold", description: ""),
    Drop(title: "Helga", description: ""),
    Drop(title: "Grandpa", description: "")]
  
  override func viewDidLoad() {
    delegate = self
    super.viewDidLoad()
  }
  
  override func numberOfDrops() -> Int {
    return data.count
  }
  
  override func dropForIndex(index: Int) -> DropProtocol? {
    return (index < data.count) ? data[index] : nil
  }
  
  override func viewForMenu() -> RoundDropMenuView? {
    return menuView
  }
  
  func didSelectDropWithIndex(index: Int) {
    // handle event
  }
}
