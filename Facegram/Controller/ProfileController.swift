//
//  ProfileController.swift
//  Facegram
//
//  Created by Dominic Ong on 1/12/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

enum ActionButtonState: String {
  case CurrentUser = "Edit Profile"
  case NotFollowing = "+ Follow"
  case Following = "✓ Following"
}

class ProfileController: UIViewController {
  @IBOutlet weak var profilePic:UIImageView!
  @IBOutlet weak var postsLabel:UILabel!
  @IBOutlet weak var followersLabel:UILabel!
  @IBOutlet weak var followingLabel:UILabel!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var logoutButton: UIBarButtonItem!
  var profileUsername = Profile.currentUser?.username // shows currentUser by default
  var userProfile: Profile?
  var actionButtonState: ActionButtonState = .CurrentUser {
    // Perform additional behaviors when a variables value is changed
    willSet(newState) {
      switch newState {
      case .CurrentUser:
        actionButton.backgroundColor = UIColor.rawColor(red: 228, green: 228, blue: 228, alpha: 1.0)
        actionButton.layer.borderWidth = 1
        actionButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
      case .NotFollowing:
        actionButton.backgroundColor = UIColor.whiteColor()
        actionButton.layer.borderColor = UIColor.rawColor(red: 18, green: 86, blue: 136, alpha: 1.0).CGColor
        actionButton.layer.borderWidth = 1
        actionButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
      case .Following:
        actionButton.backgroundColor = UIColor.rawColor(red: 111, green: 187, blue: 82, alpha: 1.0)
        actionButton.layer.borderWidth = 0
        actionButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      }
      actionButton.setTitle(newState.rawValue, forState: .Normal)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    actionButton.layer.cornerRadius = 3
    profilePic.layer.cornerRadius = 40
    profilePic.layer.masksToBounds = true
    // Fetch information about user profile
    guard let username = profileUsername else {
      print("No username for ProfileController")
      return
    }
    
    self.userProfile = Profile.currentUser
    
    if username == Profile.currentUser?.username {
      self.updateProfile()
    } else {
      logoutButton.enabled = false
      logoutButton.tintColor = UIColor.clearColor()
    }
    profileRef.childByAppendingPath(username).observeEventType(.Value, withBlock: { snapshot in
      guard let profile = snapshot.value as? [String: AnyObject] else {
        return
      }
      self.userProfile = Profile.initWithUsername(username, profileDict: profile)
      if username != Profile.currentUser?.username {
        if self.userProfile!.followers.contains(Profile.currentUser!.username) {
          self.actionButtonState = .Following
        } else {
          self.actionButtonState = .NotFollowing
        }
      }
      self.updateProfile()
      }, withCancelBlock: { error in
        print("Problem loading \(self.profileUsername)'s profile \(error.localizedDescription)")
    })
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = profileUsername // Shortened to address this vc's navigation item
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
    switch actionButtonState {
    case .CurrentUser:
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
    case .NotFollowing:
      actionButtonState = .Following
      Profile.currentUser?.following.append(userProfile!.username)
      userProfile?.followers.append(Profile.currentUser!.username)
      Profile.currentUser?.sync()
      userProfile?.sync()
    case .Following:
      actionButtonState = .NotFollowing
      if let index = Profile.currentUser?.following.indexOf(profileUsername!) {
        Profile.currentUser?.following.removeAtIndex(index)
      }
      if let index = userProfile?.followers.indexOf((Profile.currentUser?.username)!) {
        userProfile?.followers.removeAtIndex(index)
      }
      userProfile?.sync()
      Profile.currentUser?.sync()
    }
  }
  
  @IBAction func logout(sender: UIBarButtonItem) {
    postRef.removeAllObservers()
    tabBarController?.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    userProfile?.picture = info[UIImagePickerControllerEditedImage] as? UIImage
    profilePic.image = userProfile?.picture
    userProfile?.sync()
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
}
