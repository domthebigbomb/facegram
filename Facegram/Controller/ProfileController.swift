//
//  ProfileController.swift
//  Facegram
//
//  Created by Dominic Ong on 1/12/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
  @IBOutlet weak var profilePic:UIImageView!
  @IBOutlet weak var postsLabel:UILabel!
  @IBOutlet weak var followersLabel:UILabel!
  @IBOutlet weak var followingLabel:UILabel!

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let currentUser = Profile.currentUser {
      navigationController?.navigationBar.topItem?.title = currentUser.username
      self.postsLabel.text = "\(currentUser.posts.count)" // "5"  5
      self.followersLabel.text = "\(currentUser.followers.count)"
      self.followingLabel.text = "\(currentUser.following.count)"
      if let profPic = currentUser.picture {
        self.profilePic.image = profPic
      }
    } else {
      print("No user is logged in")
    }
  }
  
  @IBAction func editProfile(sender: AnyObject) {
    print("User wants to edit their profile")
  }
}
