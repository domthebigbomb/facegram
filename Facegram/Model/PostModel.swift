//
//  PostModel.swift
//  Facegram
//
//  Created by Dominic Ong on 1/12/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class Post {
  let creator: String
  let timestamp: NSDate
  let image: UIImage
  let caption: String?
  let postID: String?
  static var feed:Array<Post>?
  
  init(id: String?, creator:String, image:UIImage, caption:String?) {
    self.postID = id
    self.creator = creator
    self.image = image
    self.caption = caption
    timestamp = NSDate()
  }
  
  static func initWithPostID(postID: String, postDict: [String: String]) -> Post? {
    guard let creator = postDict["creator"],
      let base64String = postDict["image"] else {
        print("Invalid Post dictionary")
        return nil
    }
    let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    let postImage = UIImage(data: decodedData)!
    let caption = postDict["caption"]
    return Post(id: postID, creator: creator, image: postImage, caption: caption)
  }
  
  func dictValue() -> [String: String] {
    var postDict = [String: String]()
    postDict["creator"] = creator
    postDict["image"] = image.base64String()
    if let realCaption = caption {
      postDict["caption"] = realCaption
    }
    return postDict
  }
}








