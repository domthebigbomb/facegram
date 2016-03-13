//
//  FeedController.swift
//  Facegram
//
//  Created by Dominic Ong on 1/14/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class FeedController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 208
    postRef.observeEventType(.Value, withBlock: { snapshot in
        //print(snapshot.value)   // Avoid this since images will have a LONG description
      guard let posts = snapshot.value as? [String: [String: String]] else {
        print("No posts found")
        return
      }
      Post.feed?.removeAll()
      for (postID, post) in posts {
        let newPost = Post.initWithPostID(postID, postDict: post)!
        Post.feed?.append(newPost)
      }
      Post.feed = Post.feed?.reverse()
      self.tableView.reloadData()  // Refreshes our feed
      }, withCancelBlock: { error in
        print(error.localizedDescription)
    })
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let feed = Post.feed {
      return feed.count
    } else {
      return 0
    }
  }
  
  func postIndex(cellIndex: Int) -> Int {
    return tableView.numberOfSections - cellIndex - 1
  }
  
  @IBAction func viewUsersProfile(sender: UIButton!) {
    let mainSB = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let profileVC = mainSB.instantiateViewControllerWithIdentifier("Profile") as! ProfileController
    profileVC.username = sender.titleForState(.Normal)
    let barButton = UIBarButtonItem()
    barButton.title = "Back"
    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    navigationController?.navigationBar.topItem?.backBarButtonItem = barButton;
    navigationController?.pushViewController(profileVC, animated: true)
  }
  
  func showOptions(sender: UIButton!) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
    guard let indexPath = self.tableView.indexPathForRowAtPoint(buttonPosition) else {
      return
    }
    let post = Post.feed![postIndex(indexPath.section)]
    if post.creator == Profile.currentUser!.username {
      let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (alert: UIAlertAction!) -> Void in
        let postToBeDeleted = Post.feed![self.postIndex(indexPath.section)]
        let postID = postToBeDeleted.postID!
        postRef.childByAppendingPath(postID).removeValueWithCompletionBlock({ error, ref in
          if error != nil {
            print(error.localizedDescription)
          }
          print("Deleted post: \(ref.description())")
        })
      })
      actionSheet.addAction(deleteAction)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    actionSheet.addAction(cancelAction)
    self.presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let post = Post.feed![postIndex(section)]
    let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeaderCell") as? PostHeaderCell
    if post.creator == Profile.currentUser?.username {
      headerCell!.profilePicture.image = Profile.currentUser?.picture
    } else {
      // Set to creator's image
    }
    headerCell?.usernameButton.setTitle(post.creator, forState: .Normal)
    
    let headerView = UIView(frame: headerCell!.frame)
    headerView.addSubview(headerCell!)
    
    return headerView
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let post = Post.feed![postIndex(indexPath.section)]
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
    cell.captionLabel.text = post.caption
    cell.imgView.image = post.image
    cell.tripleDot.addTarget(self, action: "showOptions:", forControlEvents: .TouchUpInside)
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 48
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let post = Post.feed![postIndex(indexPath.section)]
    let aspectRatio = post.image.size.height / post.image.size.width
    return tableView.frame.size.width * aspectRatio + 80 // height accounting for buttons and caption
  }
  
}








