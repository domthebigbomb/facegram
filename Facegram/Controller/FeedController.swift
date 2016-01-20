//
//  FeedController.swift
//  Facegram
//
//  Created by Dominic Ong on 1/14/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class FeedController: UITableViewController {
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()  // Refreshes our feed
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
  
  func showOptions(sender: UIButton!) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
    let indexPath = self.tableView .indexPathForRowAtPoint(buttonPosition)
    if indexPath != nil {
      let post = Post.feed![postIndex(indexPath!.section)]
      if post.creator == Profile.currentUser!.username {
        Post.feed!.removeAtIndex(postIndex(indexPath!.section))
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (alert: UIAlertAction!) -> Void in
          self.tableView.deleteSections(NSIndexSet(index: indexPath!.section), withRowAnimation: .Automatic)
        })
        actionSheet.addAction(deleteAction)
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      actionSheet.addAction(cancelAction)
      self.presentViewController(actionSheet, animated: true, completion: nil)
    }
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
    if let img = post.image {
      let aspectRatio = img.size.height / img.size.width
      return tableView.frame.size.width * aspectRatio + 80 // height accounting for buttons and caption
    }
    return 208  // default height
  }
}








