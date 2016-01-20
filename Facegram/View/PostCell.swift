//
//  PostCell.swift
//  Facegram
//
//  Created by Dominic Ong on 1/15/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
  @IBOutlet weak var captionLabel: UILabel!
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var tripleDot: UIButton!
}

class PostHeaderCell: UITableViewCell {
  @IBOutlet weak var profilePicture: UIImageView!
  @IBOutlet weak var usernameButton: UIButton!
}