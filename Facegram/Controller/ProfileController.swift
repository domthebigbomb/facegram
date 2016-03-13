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
  @IBOutlet weak var actionButton: UIButton!
  var username = Profile.currentUser?.username // shows currentUser by default
  var userProfile: Profile?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Fetch information about user profile
    guard let username = username else {
      print("No username for ProfileController")
      return
    }
    if username != Profile.currentUser?.username {
      actionButton.backgroundColor = UIColor.whiteColor()
      actionButton.layer.borderColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1.0).CGColor
      actionButton.layer.borderWidth = 1
//      actionButton.layer.cornerRadius = 3
      actionButton.setTitle("+ Follow", forState: .Normal)
    }
    profileRef.childByAppendingPath(username).observeEventType(.Value, withBlock: { snapshot in
      print("\(username): \(snapshot.value)")
      guard let profile = snapshot.value as? [String: AnyObject] else {
        return
      }
      self.userProfile = Profile.initWithUsername(username, profileDict: profile)
      self.updateProfile()
      }, withCancelBlock: { error in
        print("Problem loading \(self.username)'s profile \(error.localizedDescription)")
    })
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = username // Shortened to address this vc's navigation item
  }
  
  func updateProfile() {
    postsLabel.text = "\(userProfile!.posts.count)" // "5"  5
    followersLabel.text = "\(userProfile!.followers.count)"
    followingLabel.text = "\(userProfile!.following.count)"
    if let profPic = userProfile?.picture {
      profilePic.image = profPic
    }
  }
  
  @IBAction func editProfile(sender: AnyObject) {
    let actionSheet = UIAlertController(title: "Edit Profile", message: nil, preferredStyle: .ActionSheet)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    let photoAction = UIAlertAction(title: "Change Photo", style: .Default, handler: { action in
      let picker = UIImagePickerController()
      picker.allowsEditing = true
      picker.sourceType = .PhotoLibrary
      picker.delegate = self
      self.presentViewController(picker, animated: true, completion: nil)
    })
    actionSheet.addAction(cancelAction)
    actionSheet.addAction(photoAction)
    presentViewController(actionSheet, animated: true, completion: nil)
  }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    userProfile?.picture = info[UIImagePickerControllerEditedImage] as? UIImage
    profilePic.image = userProfile?.picture
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
}
