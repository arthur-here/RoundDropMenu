//
//  File.swift
//  Round-Drop-Menu
//
//  Created by Arthur Myronenko on 15.05.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

class Drop: DropProtocol {
  var title: String
  var description: String
  var image: UIImage?
  
  required init(title: String, description: String, image: UIImage? = nil) {
    self.title = title
    self.description = description
    self.image = image
  }
}
