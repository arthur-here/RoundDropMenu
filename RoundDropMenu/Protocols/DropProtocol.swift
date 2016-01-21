//
//  DropProtocol.swift
//  Round-Drop Menu
//
//  Created by Arthur Myronenko on 14.05.15.
//  Copyright (c) 2015 Arthur Myronenko. All rights reserved.
//

import UIKit

// All Data Elements in Round-Drop Menu must confirm to this protocol

protocol DropType {
  var title: String { get set }
  var description: String { get set }
  var image: UIImage? { get set }
  
  init(title: String, description: String, image: UIImage?)
}