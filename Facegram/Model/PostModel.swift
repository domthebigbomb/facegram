//
//  PostModel.swift
//  Facegram
//
//  Created by Dominic Ong on 1/12/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class Post {
  let creator:String
  let timestamp:NSDate
  let image:UIImage?
  let caption:String?
  static var feed:Array<Post>?
  
  init(creator:String, image:UIImage?, caption:String?) {
    self.creator = creator
    self.image = image
    self.caption = caption
    timestamp = NSDate()
  }
}








